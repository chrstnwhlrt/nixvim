{ lib, config, ... }:
{
  options = {
    conform.enable = lib.mkEnableOption "Enable conform module";
  };
  config = lib.mkIf config.conform.enable {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        lsp_format = "fallback";
        formatters_by_ft = {
          # java = [ "google-java-format" ];
          # python = [ "black" ];
          # lua = [ "stylua" ];
          json = [ "prettierd" ];
          yaml = [ "prettierd" ];
          markdown = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          javascriptreact = [ "prettierd" ];
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          html = [ "prettierd" ];
          css = [ "prettierd" ];
          nix = [ "nixfmt" ];
          rust = [ "rustfmt" ];
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>uf";
        action = ":FormatToggle<CR>";
        options = {
          desc = "Toggle Format Globally";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>uF";
        action = ":FormatToggle!<CR>";
        options = {
          desc = "Toggle Format Locally";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format()<cr>";
        options = {
          silent = true;
          desc = "Format Buffer";
        };
      }
      {
        mode = "v";
        key = "<leader>cF";
        action = "<cmd>lua require('conform').format()<cr>";
        options = {
          silent = true;
          desc = "Format Lines";
        };
      }
    ];
  };
}
