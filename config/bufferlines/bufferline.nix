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
          # Transparent tab bar: bufferline generates highlights from
          # this table after every ColorScheme event, so setting it
          # plugin-natively is more robust than overriding highlights
          # post-hoc from the colorscheme module.
          highlights =
            let t = { bg = "NONE"; }; in
            {
              fill                   = t;
              background             = t;
              buffer_selected        = t // { bold = true; italic = false; };
              buffer_visible         = t;
              separator              = t;
              separator_selected     = t;
              separator_visible      = t;
              indicator_selected     = t;
              modified               = t;
              modified_selected      = t;
              modified_visible       = t;
              duplicate              = t;
              duplicate_selected     = t;
              duplicate_visible      = t;
              numbers                = t;
              numbers_selected       = t;
              numbers_visible        = t;
              close_button           = t;
              close_button_selected  = t;
              close_button_visible   = t;
              tab                    = t;
              tab_selected           = t;
              tab_close              = t;
              error                  = t;
              error_selected         = t;
              error_visible          = t;
              warning                = t;
              warning_selected       = t;
              warning_visible        = t;
              info                   = t;
              info_selected          = t;
              info_visible           = t;
              hint                   = t;
              hint_selected          = t;
              hint_visible           = t;
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
