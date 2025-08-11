{ lib, config, ... }:
{
  options = {
    bufferline.enable = lib.mkEnableOption "Enable bufferline module";
  };
  config = lib.mkIf config.bufferline.enable {
    plugins = {
      bufferline = {
        enable = true;
        settings = {
          options = {
            separatorStyle = "thin"; # “slant”, “padded_slant”, “slope”, “padded_slope”, “thick”, “thin“
            diagnostics = "nvim_lsp";
            custom_filter = ''
              function(buf_number, buf_numbers)
                 -- Exclude quickfix buffers
                 if vim.bo[buf_number].filetype ~= "qf" then
                   return true
                 end
               end
            '';
          };
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }

      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }

      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = {
          desc = "Delete buffer";
        };
      }

      {
        mode = "n";
        key = "<leader>bb";
        action = "<cmd>e #<cr>";
        options = {
          desc = "Switch to Other Buffer";
        };
      }

      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>BufferLineCloseOthers<cr>";
        options = {
          desc = "Delete other buffers";
        };
      }

      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>BufferLineTogglePin<cr>";
        options = {
          desc = "Toggle pin";
        };
      }

      {
        mode = "n";
        key = "<leader>bP";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options = {
          desc = "Delete non-pinned buffers";
        };
      }
    ];
  };
}
