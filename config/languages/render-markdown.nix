{ lib, config, ... }:
{
  options = {
    render-markdown.enable = lib.mkEnableOption "Enable render-markdown inline renderer";
  };
  config = lib.mkIf config.render-markdown.enable {
    plugins.render-markdown = {
      enable = true;
      settings = {
        # Render only in normal mode so you can still edit raw markdown
        # without symbols in the way.
        render_modes = [ "n" "c" "t" ];
        # Uses web-devicons (already enabled) for filetype icons in code
        # blocks; no extra dep.
        completions.lsp.enabled = true;
        anti_conceal.enabled = true;
        heading = {
          sign = false;
          width = "block";
          left_pad = 1;
          right_pad = 2;
        };
        code = {
          sign = false;
          width = "block";
          left_pad = 1;
          right_pad = 2;
        };
        bullet = {
          icons = [ "●" "○" "◆" "◇" ];
        };
        checkbox = {
          unchecked.icon = "󰄱 ";
          checked.icon = "󰱒 ";
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>cp";
        action = "<cmd>RenderMarkdown toggle<cr>";
        options = {
          silent = true;
          desc = "Toggle inline markdown render";
        };
      }
    ];
  };
}
