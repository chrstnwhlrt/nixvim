{ lib, config, pkgs, ... }:
{
  options = {
    base16-noctalia.enable = lib.mkEnableOption "Enable base16 noctalia dynamic theming";
  };
  config = lib.mkIf config.base16-noctalia.enable {
    extraPlugins = [ pkgs.vimPlugins.base16-nvim ];

    # Dynamic theming bridge for noctalia's matugen-generated palette.
    #
    # Data flow:
    #   noctalia -> matugen template engine -> ~/.config/nvim/lua/matugen.lua
    #                                         (sets base16 colors from wallpaper)
    #   noctalia -> SIGUSR1 to nvim           (on wallpaper change)
    #
    # This module owns the SIGUSR1 handler end-to-end so that every theme
    # application — initial load and every hot-reload — goes through the
    # same apply() path, keeping transparency/lualine/plugin overrides in
    # lock-step with the base16 palette. matugen.lua's own signal handler
    # is neutralized at load time to prevent handler stacking and ordering
    # races (its handler does not re-run our overrides).
    extraConfigLuaPost = ''
      -- Nixvim's runtimepath does not include ~/.config/nvim; extend
      -- package.path so require('matugen') resolves the user file.
      local user_lua = vim.fn.expand('~/.config/nvim/lua/?.lua')
      if not package.path:find(user_lua, 1, true) then
        package.path = package.path .. ';' .. user_lua
      end

      -- Hardcoded fallback palette (warm dark, matugen-shaped) used when
      -- ~/.config/nvim/lua/matugen.lua is not present. Keeps this flake
      -- usable on machines without noctalia (servers, demos, CI).
      local fallback_palette = {
        base00 = '#181211', base01 = '#251e1e', base02 = '#2f2828', base03 = '#a08c8b',
        base04 = '#d8c2c0', base05 = '#ede0de', base06 = '#ede0de', base07 = '#ede0de',
        base08 = '#ffb4ab', base09 = '#e2c28c', base0A = '#e7bdb9', base0B = '#ffb3ae',
        base0C = '#e2c28c', base0D = '#ffb3ae', base0E = '#e7bdb9', base0F = '#93000a',
      }

      -- Load (or reload) matugen with its SIGUSR1 handler stubbed out.
      -- matugen.lua is a generated file we do not control; neutralizing
      -- vim.uv.new_signal during its load prevents it from installing
      -- a handler of its own.
      local function load_matugen()
        local real = vim.uv.new_signal
        vim.uv.new_signal = function()
          return {
            start = function() end,
            stop = function() end,
            close = function() end,
          }
        end
        package.loaded['matugen'] = nil
        local ok, mod = pcall(require, 'matugen')
        vim.uv.new_signal = real
        if ok and type(mod) == 'table' and type(mod.setup) == 'function' then
          return mod
        end
        return nil
      end

      -- Plugin-specific highlight groups that base16 does not define.
      -- Linking them to base16 slots so each plugin follows the dynamic
      -- palette instead of its own hardcoded defaults.
      local plugin_links = {
        -- BufferLine
        BufferLineFill                = 'TabLineFill',
        BufferLineBackground          = 'TabLine',
        BufferLineBufferSelected      = 'Function',
        BufferLineBufferVisible       = 'Comment',
        BufferLineSeparator           = 'TabLineFill',
        BufferLineSeparatorSelected   = 'TabLineFill',
        BufferLineSeparatorVisible    = 'TabLineFill',
        BufferLineIndicatorSelected   = 'Function',
        BufferLineModifiedSelected    = 'String',
        -- Trouble
        TroubleNormal                 = 'Normal',
        TroubleNormalNC               = 'NormalNC',
        TroubleText                   = 'Normal',
        TroubleTitle                  = 'Function',
        TroubleCount                  = 'Function',
        -- WhichKey
        WhichKey                      = 'Function',
        WhichKeyGroup                 = 'Keyword',
        WhichKeyDesc                  = 'Normal',
        WhichKeySeparator             = 'Comment',
        WhichKeyFloat                 = 'NormalFloat',
        WhichKeyBorder                = 'FloatBorder',
        WhichKeyValue                 = 'Comment',
        -- Barbecue winbar breadcrumbs
        BarbecueEllipsis              = 'Comment',
        BarbecueSeparator             = 'Comment',
        BarbecueModified              = 'DiagnosticWarn',
        BarbecueNormal                = 'Normal',
      }

      -- Surfaces that should stay transparent so the terminal background
      -- shows through. base16 paints a solid base00 on these by default;
      -- we clear bg per-surface instead (popups/statusline stay solid).
      local transparent_groups = {
        'Normal', 'NormalNC', 'EndOfBuffer',
        'SignColumn', 'LineNr', 'CursorLineNr',
        'FoldColumn', 'VertSplit', 'WinSeparator',
      }

      -- BufferLine tab bar transparency is a two-step job:
      --   1. Plugin-native `highlights = { ... }` table in
      --      config/bufferlines/bufferline.nix — survives bufferline's
      --      own ColorScheme-triggered highlight regeneration.
      --   2. Post-hoc clear on base16's own BufferLine* assignments —
      --      base16-colorscheme.setup() (called by matugen.setup()) writes
      --      its own bg for the generic BufferLine* surfaces, overriding
      --      whatever we passed to bufferline's config. We override again.
      -- Both are needed; neither alone is sufficient.
      local bufferline_transparent_groups = {
        'BufferLineFill', 'BufferLineBackground',
        'BufferLineBufferSelected', 'BufferLineBufferVisible', 'BufferLineBuffer',
        'BufferLineSeparator', 'BufferLineSeparatorSelected', 'BufferLineSeparatorVisible',
        'BufferLineIndicator', 'BufferLineIndicatorSelected', 'BufferLineIndicatorVisible',
        'BufferLineModified', 'BufferLineModifiedSelected', 'BufferLineModifiedVisible',
        'BufferLineDuplicate', 'BufferLineDuplicateSelected', 'BufferLineDuplicateVisible',
        'BufferLineNumbers', 'BufferLineNumbersSelected', 'BufferLineNumbersVisible',
        'BufferLineCloseButton', 'BufferLineCloseButtonSelected', 'BufferLineCloseButtonVisible',
        'BufferLineTab', 'BufferLineTabSelected', 'BufferLineTabClose',
        'BufferLineError', 'BufferLineErrorSelected', 'BufferLineErrorVisible',
        'BufferLineWarning', 'BufferLineWarningSelected', 'BufferLineWarningVisible',
        'BufferLineInfo', 'BufferLineInfoSelected', 'BufferLineInfoVisible',
        'BufferLineHint', 'BufferLineHintSelected', 'BufferLineHintVisible',
      }

      -- Floating windows we want transparent. Snacks picker uses
      -- winhighlight to remap Normal/NormalFloat to its own Snacks*
      -- group names, which are regenerated internally after our apply()
      -- runs — so we target both the generic NormalFloat fallback AND
      -- every Snacks* / WhichKey* surface we can enumerate. fg is
      -- preserved the same way we do it for bufferline.
      --
      -- Deliberately NOT in this list (must keep their bg so the user
      -- can see what is selected / hovered):
      --   *CursorLine, *Selected, *Match, *MenuSelection,
      --   *SignatureHelpActiveParameter
      local float_transparent_groups = {
        -- Generic floating window background (catches any popup that
        -- doesn't bind winhighlight, e.g. LSP hover, blink.cmp menu).
        'NormalFloat', 'FloatBorder', 'FloatTitle', 'FloatFooter',
        -- snacks core
        'SnacksNormal', 'SnacksNormalNC', 'SnacksWinBar', 'SnacksWinBarNC',
        'SnacksWinSeparator', 'SnacksTitle', 'SnacksFooter',
        'SnacksBackdrop', 'SnacksDim',
        -- blink.cmp completion menu + documentation + signature help
        'BlinkCmpMenu', 'BlinkCmpMenuBorder',
        'BlinkCmpDoc', 'BlinkCmpDocBorder', 'BlinkCmpDocSeparator',
        'BlinkCmpSignatureHelp', 'BlinkCmpSignatureHelpBorder',
        'BlinkCmpLabel', 'BlinkCmpLabelDeprecated',
        'BlinkCmpLabelDetail', 'BlinkCmpLabelDescription',
        'BlinkCmpKind', 'BlinkCmpSource', 'BlinkCmpGhostText',
        -- snacks.picker (outer box + input + list + preview sub-windows)
        'SnacksPicker', 'SnacksPickerNormal',
        'SnacksPickerBox', 'SnacksPickerBoxBorder', 'SnacksPickerBoxTitle',
        'SnacksPickerInput', 'SnacksPickerInputBorder', 'SnacksPickerInputTitle',
        'SnacksPickerInputFooter',
        'SnacksPickerList', 'SnacksPickerListBorder', 'SnacksPickerListTitle',
        'SnacksPickerListFooter',
        'SnacksPickerPreview', 'SnacksPickerPreviewBorder', 'SnacksPickerPreviewTitle',
        'SnacksPickerPreviewFooter',
        'SnacksPickerBorder', 'SnacksPickerTitle',
        'SnacksPickerRow', 'SnacksPickerPrompt',
        -- which-key popup
        'WhichKeyNormal', 'WhichKeyBorder', 'WhichKeyTitle', 'WhichKeyFloat',
      }

      local function hex(name, attr, fallback)
        local h = vim.api.nvim_get_hl(0, { name = name, link = false })
        return h[attr] and string.format('#%06x', h[attr]) or fallback
      end

      -- Derive a lualine theme from the live base16 highlights so mode
      -- badges and sections match the matugen palette. lualine's
      -- theme="auto" cannot resolve our custom base16 scheme on its own.
      local function build_lualine_theme()
        local bg      = hex('Normal',          'bg', '#181211')
        local fg      = hex('Normal',          'fg', '#ede0de')
        local subtle  = hex('Comment',         'fg', '#a08c8b')
        local darker  = hex('CursorLine',      'bg', '#251e1e')
        local primary = hex('Function',        'fg', '#ffb3ae')
        local accent2 = hex('Type',            'fg', '#e7bdb9')
        local accent3 = hex('Keyword',         'fg', '#e7bdb9')
        local warn    = hex('DiagnosticWarn',  'fg', '#e2c28c')
        local err     = hex('DiagnosticError', 'fg', '#ffb4ab')
        local function mode(a_bg)
          return {
            a = { fg = bg, bg = a_bg,   gui = 'bold' },
            b = { fg = fg, bg = darker },
            c = { fg = fg, bg = 'NONE' },
          }
        end
        return {
          normal   = mode(primary),
          insert   = mode(accent2),
          visual   = mode(accent3),
          replace  = mode(err),
          command  = mode(warn),
          inactive = {
            a = { fg = subtle, bg = 'NONE' },
            b = { fg = subtle, bg = 'NONE' },
            c = { fg = subtle, bg = 'NONE' },
          },
        }
      end

      local function apply_fallback()
        return pcall(function()
          require('base16-colorscheme').setup(fallback_palette)
        end)
      end

      -- Single source of truth for applying the theme. Called on initial
      -- load and on every SIGUSR1 (wallpaper change). Uses the generated
      -- matugen palette when available, falls back to the hardcoded one
      -- if matugen is missing OR its setup fails (e.g. corrupt template).
      local function apply()
        local matugen = load_matugen()
        local setup_ok = matugen ~= nil and pcall(matugen.setup)
        if not setup_ok then
          setup_ok = apply_fallback()
        end
        if not setup_ok then return false end

        vim.g.colors_name = 'base16-noctalia'

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
        end
        for name, target in pairs(plugin_links) do
          vim.api.nvim_set_hl(0, name, { link = target })
        end
        -- Override bg = NONE while preserving fg on groups where we
        -- want transparency but need to keep the existing text color
        -- (bufferline tabs, snacks.picker surfaces, which-key popup).
        local function clear_bg_keep_fg(groups)
          for _, group in ipairs(groups) do
            local resolved = vim.api.nvim_get_hl(0, { name = group, link = false })
            local attrs = { bg = 'NONE' }
            if resolved.fg   then attrs.fg   = resolved.fg end
            if resolved.bold then attrs.bold = resolved.bold end
            if resolved.italic then attrs.italic = resolved.italic end
            vim.api.nvim_set_hl(0, group, attrs)
          end
        end
        clear_bg_keep_fg(bufferline_transparent_groups)
        clear_bg_keep_fg(float_transparent_groups)

        -- Snacks (picker in particular) regenerates some of its
        -- highlight groups lazily — on first picker open, not at
        -- startup. Re-apply float-group transparency whenever snacks
        -- spawns one of its filetypes or fires its custom User events.
        -- The augroup is cleared on re-entry so we don't stack
        -- callbacks across repeated apply() invocations (SIGUSR1).
        vim.api.nvim_create_autocmd({ 'FileType', 'User' }, {
          group = vim.api.nvim_create_augroup('NoctaliaSnacksTransparent', { clear = true }),
          pattern = { 'snacks_*', 'SnacksWinOpen', 'SnacksPickerOpen' },
          callback = function()
            clear_bg_keep_fg(float_transparent_groups)
          end,
        })

        pcall(function()
          local lualine = require('lualine')
          local cfg = lualine.get_config()
          cfg.options.theme = build_lualine_theme()
          lualine.setup(cfg)
        end)
        return true
      end

      -- Own the SIGUSR1 handler (noctalia's wallpaper-change signal).
      -- Using a module-global so reloading this config idempotently
      -- replaces any previously installed handler instead of stacking.
      if _G.__noctalia_sigusr1 then
        pcall(function() _G.__noctalia_sigusr1:stop() end)
        pcall(function() _G.__noctalia_sigusr1:close() end)
      end
      local sig = vim.uv.new_signal()
      sig:start('sigusr1', vim.schedule_wrap(apply))
      _G.__noctalia_sigusr1 = sig

      apply()
    '';
  };
}
