{ lib, config, ... }:
{
  options = {
    snacks.enable = lib.mkEnableOption "Enable snacks module";
  };
  config = lib.mkIf config.snacks.enable {
    plugins.snacks = {
      enable = true;
      settings = {
        # Startup dashboard (replaces alpha.nvim).
        dashboard = {
          enabled = true;
          preset = {
            header = ''
               ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
               ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
               ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
               ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
               ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
               ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝'';
            keys = [
              {
                icon = " ";
                key = "f";
                desc = "Find File";
                action.__raw = "function() Snacks.picker.files() end";
              }
              {
                icon = " ";
                key = "n";
                desc = "New File";
                action = ":ene | startinsert";
              }
              {
                icon = "󰈚 ";
                key = "r";
                desc = "Recent Files";
                action.__raw = "function() Snacks.picker.recent() end";
              }
              {
                icon = "󰈭 ";
                key = "g";
                desc = "Find Word";
                action.__raw = "function() Snacks.picker.grep() end";
              }
              {
                icon = " ";
                key = "s";
                desc = "Browse CWD";
                action = ":e .";
              }
              {
                icon = " ";
                key = "q";
                desc = "Quit Neovim";
                action = ":qa";
              }
            ];
          };
          sections = [
            { section = "header"; }
            { section = "keys"; gap = 1; padding = 1; }
            {
              pane = 2;
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              indent = 2;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Projects";
              section = "projects";
              indent = 2;
              padding = 1;
            }
            { section = "startup"; }
          ];
        };

        # Notification stack (replaces noice.nvim + dressing.nvim input/select).
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        notify.enabled = true;

        # vim.ui.input/select are patched by dressing.nvim, which is pulled
        # in as a transitive dep of avante.nvim and cannot trivially be
        # excluded. Disabling snacks.input here avoids a conflict.
        input.enabled = false;

        # Unified picker: backs the dashboard, vim.ui.select (when dressing
        # delegates), and the Stage 3 keymap migration.
        picker.enabled = true;

        # Misc QoL modules.
        quickfile.enabled = true;
        words = {
          enabled = true;
          debounce = 100;
        };

        # Indent guides (replaces indent-blankline.nvim).
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
