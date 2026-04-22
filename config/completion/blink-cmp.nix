{ lib, config, ... }:
{
  options = {
    blink-cmp.enable = lib.mkEnableOption "Enable blink.cmp completion engine";
  };
  config = lib.mkIf config.blink-cmp.enable {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        # Explicit mappings (preset=none) so every binding is accounted for.
        # Preserves the full nvim-cmp keymap surface of the old config.
        keymap = {
          preset = "none";
          "<C-j>" = [ "select_next" "fallback" ];
          "<C-k>" = [ "select_prev" "fallback" ];
          "<C-n>" = [ "select_next" "fallback" ];
          "<C-p>" = [ "select_prev" "fallback" ];
          "<Tab>" = [ "select_next" "snippet_forward" "fallback" ];
          "<S-Tab>" = [ "select_prev" "snippet_backward" "fallback" ];
          "<C-e>" = [ "hide" "fallback" ];
          "<C-f>" = [ "scroll_documentation_down" "fallback" ];
          "<C-b>" = [ "scroll_documentation_up" "fallback" ];
          "<C-Space>" = [ "show" "show_documentation" "hide_documentation" ];
          "<CR>" = [ "accept" "fallback" ];
        };

        # LuaSnip drives snippet expansion; friendly-snippets is loaded there.
        snippets.preset = "luasnip";

        # Rust fuzzy matcher — the main performance win over nvim-cmp.
        fuzzy.implementation = "prefer_rust_with_warning";

        completion = {
          # Silence auto-completion noise in markdown: no popup-while-
          # typing, no inline ghost-text. <C-Space> still triggers the
          # menu manually (see keymap above).
          ghost_text.enabled.__raw = ''function() return vim.bo.filetype ~= "markdown" end'';
          accept.auto_brackets.enabled = true;

          menu = {
            auto_show.__raw = ''function() return vim.bo.filetype ~= "markdown" end'';
            border = "rounded";
            draw = {
              columns = [
                { __unkeyed-1 = "kind_icon"; }
                {
                  __unkeyed-1 = "label";
                  __unkeyed-2 = "label_description";
                  gap = 1;
                }
              ];
            };
          };

          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window.border = "rounded";
          };

          list.max_items = 30;
        };

        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];
          providers = {
            buffer.min_keyword_length = 5;
            path.min_keyword_length = 3;
            snippets.min_keyword_length = 3;
          };
        };

        # Cmdline completion (subsumes cmp.setup.cmdline for / ? :).
        cmdline = {
          enabled = true;
          keymap.preset = "cmdline";
          completion.menu.auto_show = true;
        };

        # Nerd-Font kind icons — carries over the pictograms from the old
        # kind_icons table verbatim.
        appearance = {
          nerd_font_variant = "mono";
          kind_icons = {
            Text = "󰊄";
            Method = "";
            Function = "󰡱";
            Constructor = "";
            Field = "";
            Variable = "󱀍";
            Class = "";
            Interface = "";
            Module = "󰕳";
            Property = "";
            Unit = "";
            Value = "";
            Enum = "";
            Keyword = "";
            Snippet = "";
            Color = "";
            File = "";
            Reference = "";
            Folder = "";
            EnumMember = "";
            Constant = "";
            Struct = "";
            Event = "";
            Operator = "";
            TypeParameter = "";
          };
        };
      };
    };
  };
}
