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

        # vim.ui.input replacement. dressing.nvim is pulled in as a
        # transitive dep of avante.nvim but is neutralized below in
        # extraConfigLuaPost so snacks owns the UI hooks.
        input.enabled = true;

        # Unified picker: backs the dashboard, vim.ui.select, and the
        # keymap migration.
        picker.enabled = true;

        # Misc QoL modules.
        quickfile.enabled = true;
        words = {
          enabled = true;
          debounce = 100;
        };
        # Auto-disable treesitter/LSP for files > 1.5MB to keep editing
        # responsive on huge logs, generated code, minified bundles.
        bigfile = {
          enabled = true;
          notify = true;
          size = 1.5 * 1024 * 1024;
        };
        # Smooth cursor-and-window scrolling (cheap, improves perceived
        # latency for <C-d>/<C-u>, G, gg, etc.).
        scroll.enabled = true;

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
                  "help", "dashboard", "snacks_dashboard",
                  "NvimTree", "Trouble", "trouble",
                  "lazy", "mason", "notify",
                  "toggleterm",
                }, vim.bo[buf].filetype)
            end
          '';
        };
      };
    };

    # vim.ui hook ownership.
    #
    # dressing.nvim rides in as a transitive dep of avante.nvim (not
    # something we ask for ourselves). When present, its plugin/*.lua
    # auto-patches vim.ui.input and vim.ui.select at startup. We silence
    # that auto-patch (if dressing is there at all — pcall-guarded, so
    # it's a no-op when avante is disabled) and re-bind the hooks to
    # snacks ourselves. End state: Snacks.input / Snacks.picker.select
    # always own the UI, regardless of whether dressing is loaded.
    extraConfigLuaPost = ''
      pcall(function()
        require('dressing').setup({
          input = { enabled = false },
          select = { enabled = false },
        })
      end)
      vim.ui.input = function(opts, on_confirm)
        return Snacks.input(opts, on_confirm)
      end
      vim.ui.select = function(items, opts, on_choice)
        return Snacks.picker.select(items, opts, on_choice)
      end
    '';
  };
}
