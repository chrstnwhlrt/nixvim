{ lib, config, ... }:
{
  options = {
    snacks.enable = lib.mkEnableOption "Enable snacks module";
  };
  config = lib.mkIf config.snacks.enable {
    plugins.snacks = {
      enable = true;
      settings = {
        dashboard = {
          enabled = false;
          preset = {
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action = "<leader>ff";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = " ";
                key = "/";
                desc = "Find Text";
                action = "<leader>fr";
              }
              {
                icon = " ";
                key = "r";
                desc = "Recent Files";
                action = "<leader>fg";
              }
              {
                icon = "";
                key = "o";
                desc = "LazyGit";
                action = "<leader>gg";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit";
                action = ":qa";
              }
            ];
          };
          sections = [
            {
              icon = " ";
              pane = 2;
              title = "Keymaps";
              section = "keys";
              padding = 1;
              indent = 3;
            }
            {
              icon = " ";
              pane = 2;
              title = "Recent Files";
              section = "recent_files";
              padding = 1;
              indent = 3;
            }
            {
              icon = " ";
              pane = 2;
              title = "Projects";
              section = "projects";
              padding = 1;
              indent = 3;
            }
          ];
        };
        notify.enabled = true;
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        quickfile = {
          enabled = true;
        };
        words = {
          debounce = 100;
          enabled = true;
        };
        indent = {
          enabled = true;
          char = "│";
          scope = {
            enabled = true;
            char = "│";
          };
          chunk.enabled = false;
          filter.__raw = ''
            function(buf)
              return vim.g.snacks_indent ~= false
                and vim.b[buf].snacks_indent ~= false
                and vim.bo[buf].buftype == ""
                and not vim.tbl_contains({
                  "help", "alpha", "dashboard", "snacks_dashboard",
                  "neo-tree", "NvimTree", "Trouble", "trouble",
                  "lazy", "mason", "notify",
                  "toggleterm", "lazyterm", "nvterm",
                }, vim.bo[buf].filetype)
            end
          '';
        };
      };
    };
  };
}
