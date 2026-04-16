{ lib, config, ... }:
{
  options = {
    mini.enable = lib.mkEnableOption "Enable mini module";
  };
  config = lib.mkIf config.mini.enable {
    plugins.mini = {
      enable = true;
      # nixvim's built-in devicons shim: declares to nixvim's eval that
      # mini.icons is the icon provider and auto-installs the
      # package.preload hook so every require("nvim-web-devicons") hits
      # mini.icons instead. Replaces the manual preload we used before.
      mockDevIcons = true;
      # mini.ai is intentionally NOT listed here. nixvim's mini wrapper
      # does not let us pass __raw Lua into custom_textobjects, so we
      # configure mini.ai ourselves via extraConfigLuaPost below. Only
      # declarative-friendly modules live in this table.
      modules = {
        comment = { };
        # Auto-pairs for (), [], {}, "", '', ``. Replaces nvim-autopairs
        # with a lighter, TS-aware impl that's already bundled in mini.
        pairs = { };
        # Unified icon provider (files, filetypes, LSP kinds, directories).
        # Supersedes nvim-web-devicons with caching and ASCII fallback.
        icons = { };
      };
    };

    # mini.ai setup with treesitter-based textobjects (replaces
    # nvim-treesitter-textobjects). Mirrors the original keymap surface:
    # af/if, ac/ic, aa/ia, ai/ii, al/il, at.
    extraConfigLuaPost = ''
      local ai = require('mini.ai')
      local ts = ai.gen_spec.treesitter
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ts({ a = '@function.outer',    i = '@function.inner' }),
          c = ts({ a = '@class.outer',       i = '@class.inner' }),
          a = ts({ a = '@parameter.outer',   i = '@parameter.inner' }),
          i = ts({ a = '@conditional.outer', i = '@conditional.inner' }),
          l = ts({ a = '@loop.outer',        i = '@loop.inner' }),
          t = ts({ a = '@comment.outer',     i = '@comment.outer' }),
        },
      })
    '';
  };
}
