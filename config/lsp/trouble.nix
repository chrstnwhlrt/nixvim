{ lib, config, ... }:
{
  options = {
    trouble.enable = lib.mkEnableOption "Enable trouble module";
  };
  config = lib.mkIf config.trouble.enable {
    plugins.trouble = {
      enable = true;
      settings = {
        auto_close = true;
      };
    };
    # The "+diagnostics/quickfix" group label for <leader>x lives in
    # which-key's spec (config/utils/which-key.nix), not here — a real
    # mapping with that string as rhs would feed it as literal keys.
    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options = {
          silent = true;
          desc = "Diagnostics (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options = {
          silent = true;
          desc = "Buffer Diagnostics (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xt";
        action = "<cmd>Trouble todo<cr>";
        options = {
          silent = true;
          desc = "Todo (Trouble)";
        };
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options = {
          silent = true;
          desc = "Quickfix List (Trouble)";
        };
      }
    ];
  };
}
