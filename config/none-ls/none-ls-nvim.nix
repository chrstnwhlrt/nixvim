{ lib, config, ... }:
{
  options = {
    none-ls-nvim.enable = lib.mkEnableOption "Enable none-ls-nvim module";
  };
  config = lib.mkIf config.none-ls-nvim.enable {
    plugins.none-ls = {
      enable = true;
      settings = {
        enableLspFormat = false;
        updateInInsert = false;
      };
      sources = {
        code_actions = {
          gitsigns.enable = true;
          statix.enable = true;
        };
        diagnostics = {
          checkstyle = {
            enable = true;
          };
          statix = {
            enable = true;
          };
        };
        formatting = {
          alejandra = {
            enable = false;
          };
          nixfmt = {
            enable = false;
          };
          prettier = {
            enable = false;
            settings = ''
              {
                             extra_args = { 
                                 "--bracket-same-line", "true",
                                 "--single-quote", "false",
                                 "--trailing-comma", "all",
                                 "--no-semi",
                                 "--arrow-parens", "avoid",
                                 "--print-width", "160",
                                 "--tab-width", "4",
                                 "--indent", "4"
                             }
                         } '';
          };
          google_java_format = {
            enable = false;
          };
          stylua = {
            enable = false;
          };
          black = {
            enable = false;
            settings = ''
              {
                extra_args = { "--fast" },
              }
            '';
          };
        };
      };
    };
    # keymaps = [
    #   {
    #     mode = [ "n" "v" ];
    #     key = "<leader>cf";
    #     action = "<cmd>lua vim.lsp.buf.format()<cr>";
    #     options = {
    #       silent = true;
    #       desc = "Format";
    #     };
    #   }
    # ];
  };
}
