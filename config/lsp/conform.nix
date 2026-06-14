{ lib, config, pkgs, ... }:
{
  options = {
    conform.enable = lib.mkEnableOption "Enable conform module";
  };
  config = lib.mkIf config.conform.enable {
    # Make the formatter binaries we reference below available on PATH.
    # nixvim only auto-provides LSP server binaries, not conform's formatter
    # binaries — so every formatter that isn't already an enabled LSP
    # server (taplo, ruff) must be pulled in explicitly. This keeps the
    # flake self-contained instead of silently depending on host packages.
    extraPackages = with pkgs; [
      nixfmt
      prettierd
      rustfmt
      shfmt
      stylua
    ];
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        lsp_format = "fallback";
        # Format-on-save hook, honouring the :FormatToggle commands below.
        # OFF by default (see globals.disable_autoformat) — saving never
        # reformats unless explicitly enabled for the session/buffer.
        # Returning nil skips formatting for that write.
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 1000, lsp_format = "fallback" }
          end
        '';
        formatters_by_ft = {
          json = [ "prettierd" ];
          json5 = [ "prettierd" ];
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
          python = [ "ruff_format" "ruff_organize_imports" ];
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
          zsh = [ "shfmt" ];
          toml = [ "taplo" ];
          lua = [ "stylua" ];
        };
      };
    };

    # Format-on-save is opt-in per session: the master switch starts
    # disabled, <leader>uf / :FormatToggle flips it on. The buffer-local
    # toggle only adds exceptions on top of the global switch.
    globals.disable_autoformat = true;

    # :FormatToggle (global) / :FormatToggle! (buffer-local). The keymaps
    # below referenced this command without it ever being defined; now it
    # backs the format_on_save hook above.
    userCommands.FormatToggle = {
      bang = true;
      desc = "Toggle format-on-save (! = buffer-local)";
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = not vim.b.disable_autoformat
            vim.notify(("Format-on-save (buffer): %s")
              :format(vim.b.disable_autoformat and "off" or "on"))
          else
            vim.g.disable_autoformat = not vim.g.disable_autoformat
            vim.notify(("Format-on-save (global): %s")
              :format(vim.g.disable_autoformat and "off" or "on"))
          end
        end
      '';
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>uf";
        action = ":FormatToggle<CR>";
        options = {
          desc = "Toggle format-on-save (global)";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>uF";
        action = ":FormatToggle!<CR>";
        options = {
          desc = "Toggle format-on-save (buffer)";
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
