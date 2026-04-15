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

      -- Plugin-specific highlight groups that tokyonight sets directly and
      -- base16 does not know about. Linking them to base16 slots lets them
      -- follow the dynamic palette.
      local plugin_links = {
        -- Alpha dashboard
        AlphaHeader                   = 'Function',
        AlphaButtons                  = 'Type',
        AlphaShortcut                 = 'Keyword',
        AlphaFooter                   = 'Comment',
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
        -- NvimTree
        NvimTreeNormal                = 'Normal',
        NvimTreeNormalNC              = 'NormalNC',
        NvimTreeEndOfBuffer           = 'EndOfBuffer',
        NvimTreeFolderName            = 'Directory',
        NvimTreeOpenedFolderName      = 'Directory',
        NvimTreeEmptyFolderName       = 'Directory',
        NvimTreeRootFolder            = 'Function',
        NvimTreeIndentMarker          = 'Comment',
        NvimTreeGitDirty              = 'DiagnosticWarn',
        NvimTreeGitNew                = 'DiagnosticOk',
        NvimTreeGitDeleted            = 'DiagnosticError',
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
      }

      -- Surfaces that should stay transparent so the terminal background
      -- shows through (tokyonight does this via transparent=true; base16
      -- paints a solid base00 over everything).
      local transparent_groups = {
        'Normal', 'NormalNC', 'EndOfBuffer',
        'SignColumn', 'LineNr', 'CursorLineNr',
        'FoldColumn', 'VertSplit', 'WinSeparator',
      }

      local function hex(name, attr, fallback)
        local h = vim.api.nvim_get_hl(0, { name = name, link = false })
        return h[attr] and string.format('#%06x', h[attr]) or fallback
      end

      -- Derive a lualine theme from the live base16 highlights so mode
      -- badges and sections match the matugen palette. lualine's
      -- theme="auto" would otherwise resolve to tokyonight via
      -- vim.g.colors_name.
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

      -- Single source of truth for applying the theme. Called on initial
      -- load and on every SIGUSR1 (wallpaper change). Uses the generated
      -- matugen palette when available, falls back to the hardcoded one.
      local function apply()
        local matugen = load_matugen()
        local setup_ok
        if matugen then
          setup_ok = pcall(matugen.setup)
        else
          setup_ok = pcall(function()
            require('base16-colorscheme').setup(fallback_palette)
          end)
        end
        if not setup_ok then return false end

        vim.g.colors_name = 'base16-noctalia'

        for _, group in ipairs(transparent_groups) do
          vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
        end
        for name, target in pairs(plugin_links) do
          vim.api.nvim_set_hl(0, name, { link = target })
        end

        local ll_ok, lualine = pcall(require, 'lualine')
        if ll_ok then
          local cfg = lualine.get_config()
          cfg.options.theme = build_lualine_theme()
          lualine.setup(cfg)
        end
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
