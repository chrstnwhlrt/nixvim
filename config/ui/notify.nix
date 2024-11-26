{ lib, config, ... }:
{
  options = {
    notify.enable = lib.mkEnableOption "Enable notify module";
  };
  config = lib.mkIf config.notify.enable {
    plugins.notify = {
      enable = true;
      # backgroundColour = "#000000";
      # fps = 60;
      render = "compact";
      timeout = 2000;
      topDown = true;
      stages = "static";
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>un";
        action = ''
          <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
        '';
        options = {
          desc = "Dismiss All Notifications";
        };
      }
    ];
    extraConfigLua = ''
      local notify = require("notify")

      local function show_notification(message, level)
        notify(message, level, { title = "conform.nvim" })
      end

      function ToggleLineNumber()
        if vim.wo.number then
          vim.wo.number = false
          show_notification("Line numbers disabled", "info")
        else
          vim.wo.number = true
          vim.wo.relativenumber = false
          show_notification("Line numbers enabled", "info")
        end
      end

      function ToggleWrap()
        if vim.wo.wrap then
          vim.wo.wrap = false
          show_notification("Wrap disabled", "info")
        else
          vim.wo.wrap = true
          vim.wo.number = false
          show_notification("Wrap enabled", "info")
        end
      end

      function ToggleInlayHints()
        local is_enabled = vim.lsp.inlay_hint.is_enabled()
        vim.lsp.inlay_hint.enable(not is_enabled)
        if is_enabled then
          show_notification("Inlay Hints disabled", "info")
        else
          show_notification("Inlay Hints enabled", "info")
        end
      end
    '';
  };
}
