{ lib, config, pkgs, ... }:
let
  # The upstream nvim-treesitter repo was archived on 2026-04-03. We do
  # not use the plugin's own setup() anymore — Neovim 0.12 ships a native
  # treesitter runtime (vim.treesitter.start, vim.treesitter.foldexpr).
  #
  # What we still need from the archived world: the compiled parsers
  # (*.so) and the query files (highlights.scm etc.). Both are
  # independently maintained in nixpkgs and get updated regularly.
  #
  # These two overrides produce lean runtime plugins that carry ONLY the
  # parsers and queries — the archived Lua plugin code is stripped out,
  # so none of it ever gets sourced into Neovim.
  # Strip only plugin/*.lua (what Neovim auto-sources) — leave lua/ in
  # place so nixpkgs's require-check still passes. Nothing under lua/
  # executes unless something calls require(), and we never do.
  treesitterRuntime = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      rm -rf "$out/plugin" 2>/dev/null || true
    '';
  });

  textobjectsQueries = pkgs.vimPlugins.nvim-treesitter-textobjects.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      rm -rf "$out/plugin" 2>/dev/null || true
    '';
  });
in
{
  options = {
    treesitter-nvim.enable = lib.mkEnableOption "Enable native Neovim 0.12 treesitter integration";
  };
  config = lib.mkIf config.treesitter-nvim.enable {
    # Parsers + queries via Nix. The archived Lua plugin code is stripped.
    # treesitter-context and nvim-ts-autotag are bundled here as raw
    # extraPlugins rather than via plugins.*.enable so that nixvim's
    # "needs plugins.treesitter" dependency check stays quiet — we
    # supply treesitter ourselves (natively, not through the wrapper).
    extraPlugins = with pkgs.vimPlugins; [
      treesitterRuntime
      textobjectsQueries
      nvim-treesitter-context
      nvim-ts-autotag
    ];

    extraConfigLuaPost = ''
      -- ======================================================================
      -- Supplementary plugins (own, actively-maintained repos; set up
      -- manually since they were pulled in via extraPlugins to avoid
      -- nixvim's plugins.treesitter dependency warning).
      -- ======================================================================
      pcall(function() require('treesitter-context').setup({}) end)
      pcall(function() require('nvim-ts-autotag').setup({}) end)

      -- ======================================================================
      -- Native treesitter activation (replaces nvim-treesitter setup)
      -- ======================================================================
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterEnable', { clear = true }),
        callback = function(args)
          local buf = args.buf
          local ok = pcall(vim.treesitter.start, buf)
          if ok then
            vim.api.nvim_set_option_value('foldmethod', 'expr',
              { win = vim.api.nvim_get_current_win() })
            vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.treesitter.foldexpr()',
              { win = vim.api.nvim_get_current_win() })
          end
        end,
      })
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      -- ======================================================================
      -- Incremental selection: <C-Space> grows, <BS> shrinks. Node history
      -- lives in a buffer-local stack (capped at 100 entries to prevent
      -- unbounded growth on pathological usage) and resets when leaving
      -- visual-select mode for anything non-visual.
      -- ======================================================================
      local TS_INCR_MAX = 100
      local function select_range(sr, sc, er, ec)
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd('normal! v')
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
      end
      local function ts_grow()
        local hist = vim.b.__ts_incr_hist
        local node
        if not hist or #hist == 0 then
          node = vim.treesitter.get_node()
          hist = {}
        else
          local last = hist[#hist]
          local parser = vim.treesitter.get_parser()
          if not parser then return end
          local tree = parser:parse()[1]
          if not tree then return end
          local cur = tree:root():descendant_for_range(last.sr, last.sc, last.er, last.ec)
          node = cur and cur:parent() or nil
        end
        if not node then return end
        local sr, sc, er, ec = node:range()
        table.insert(hist, { sr = sr, sc = sc, er = er, ec = ec })
        if #hist > TS_INCR_MAX then table.remove(hist, 1) end
        vim.b.__ts_incr_hist = hist
        select_range(sr, sc, er, ec)
      end
      local function ts_shrink()
        local hist = vim.b.__ts_incr_hist
        if not hist or #hist < 2 then return end
        table.remove(hist, #hist)
        local last = hist[#hist]
        vim.b.__ts_incr_hist = hist
        select_range(last.sr, last.sc, last.er, last.ec)
      end
      vim.keymap.set({ 'n', 'x' }, '<C-Space>', ts_grow,   { desc = 'TS: grow selection' })
      vim.keymap.set('x',          '<BS>',      ts_shrink, { desc = 'TS: shrink selection' })
      -- Reset history whenever we leave visual/select for any other mode,
      -- not only normal. Fixes a small leak on v -> i / v -> c transitions.
      vim.api.nvim_create_autocmd('ModeChanged', {
        pattern = { 'v:*', 'V:*', '\22:*', 's:*', 'S:*', '\19:*' },
        callback = function(args)
          local _, new_mode = args.match:match('^(.-):(.+)$')
          if not new_mode:match('^[vVsS\22\19]') then
            vim.b.__ts_incr_hist = nil
          end
        end,
      })

      -- ======================================================================
      -- Goto-motions (]m, [m, ]], [[, ]M, [M, ][, []). Uses the textobjects
      -- query shipped with nvim-treesitter-textobjects (kept runtime-only).
      -- ======================================================================
      -- Filetypes that own heading-level motions via mkdnflow. For those,
      -- call mkdnflow's Ex commands directly — using feedkeys with 'n'
      -- (no-remap) would bypass mkdnflow's keymap and only run Vim's
      -- built-in ]]/[[; using 'm' (remap) would recurse into this handler.
      local MARKDOWN_FTS = { markdown = true, markdown_inline = true }
      local MKDN_HEADING_CMD = {
        [']]'] = 'MkdnNextHeading',
        ['[['] = 'MkdnPrevHeading',
      }
      local function goto_capture(capture, dir, edge, keyseq)
        return function()
          if keyseq and MARKDOWN_FTS[vim.bo.filetype] then
            local cmd = MKDN_HEADING_CMD[keyseq]
            if cmd then
              pcall(vim.cmd, cmd)
            end
            -- keyseq without mkdnflow equivalent ([ / ]) becomes a no-op
            -- in markdown, which is fine — @class.outer has no meaning there.
            return
          end
          local parser = vim.treesitter.get_parser()
          if not parser then return end
          local tree = parser:parse()[1]
          if not tree then return end
          local lang = parser:lang()
          local ok, query = pcall(vim.treesitter.query.get, lang, 'textobjects')
          if not ok or not query then return end
          local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))
          cur_row = cur_row - 1
          local matches = {}
          for id, node in query:iter_captures(tree:root(), 0) do
            if query.captures[id] == capture then
              local sr, sc, er, ec = node:range()
              local r = (edge == 'start') and sr or er
              local c = (edge == 'start') and sc or math.max(ec - 1, 0)
              table.insert(matches, { r = r, c = c })
            end
          end
          table.sort(matches, function(a, b)
            if a.r ~= b.r then return a.r < b.r end
            return a.c < b.c
          end)
          local target
          if dir == 'next' then
            for _, m in ipairs(matches) do
              if m.r > cur_row or (m.r == cur_row and m.c > cur_col) then
                target = m; break
              end
            end
          else
            for i = #matches, 1, -1 do
              local m = matches[i]
              if m.r < cur_row or (m.r == cur_row and m.c < cur_col) then
                target = m; break
              end
            end
          end
          if target then vim.api.nvim_win_set_cursor(0, { target.r + 1, target.c }) end
        end
      end
      vim.keymap.set('n', ']m', goto_capture('function.outer', 'next', 'start'), { desc = 'Next function start' })
      vim.keymap.set('n', '[m', goto_capture('function.outer', 'prev', 'start'), { desc = 'Prev function start' })
      vim.keymap.set('n', ']M', goto_capture('function.outer', 'next', 'end'),   { desc = 'Next function end' })
      vim.keymap.set('n', '[M', goto_capture('function.outer', 'prev', 'end'),   { desc = 'Prev function end' })
      -- Class-level motions fall back to the buffer's own ]]/[[/][/[] in
      -- markdown-family filetypes so mkdnflow's heading navigation works.
      vim.keymap.set('n', ']]', goto_capture('class.outer', 'next', 'start', ']]'), { desc = 'Next class start' })
      vim.keymap.set('n', '[[', goto_capture('class.outer', 'prev', 'start', '[['), { desc = 'Prev class start' })
      vim.keymap.set('n', '][', goto_capture('class.outer', 'next', 'end',   ']['), { desc = 'Next class end' })
      vim.keymap.set('n', '[]', goto_capture('class.outer', 'prev', 'end',   '[]'), { desc = 'Prev class end' })
    '';
  };
}
