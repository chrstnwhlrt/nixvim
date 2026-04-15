{ lib, config, ... }:
{
  options = {
    mini.enable = lib.mkEnableOption "Enable mini module";
  };
  config = lib.mkIf config.mini.enable {
    plugins.mini = {
      enable = true;
      # mini.ai is intentionally NOT listed here. nixvim's mini wrapper
      # does not let us pass __raw Lua into custom_textobjects, so we
      # configure mini.ai ourselves via extraConfigLuaPost below. Only
      # declarative-friendly modules live in this table.
      modules = {
        comment = { };
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
