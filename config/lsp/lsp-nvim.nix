{ lib, config, ... }:
{
  options = {
    lsp-nvim.enable = lib.mkEnableOption "Enable lsp-nvim module";
  };
  config = lib.mkIf config.lsp-nvim.enable {
    plugins = {
      lsp-format = {
        enable = false; # Disabled: formatting is handled by conform-nvim.
      };
      lsp = {
        enable = true;
        servers = {
          clangd = {
            enable = true;
          };
          lua_ls = {
            enable = true;
            extraOptions = {
              settings = {
                Lua = {
                  completion = {
                    callSnippet = "Replace";
                  };
                  diagnostics = {
                    globals = [ "vim" ];
                  };
                  telemetry = {
                    enabled = false;
                  };
                  hint = {
                    enable = true;
                  };
                };
              };
            };
          };
          nil_ls = {
            enable = false;
          };
          nixd = {
            enable = true;
          };
          arduino_language_server = {
            enable = true;
          };
          bashls = {
            enable = true;
          };
          cssls = {
            enable = true;
          };
          dockerls = {
            enable = true;
          };
          gopls = {
            enable = true;
          };
          html = {
            enable = true;
          };
          jdtls = {
            enable = true;
          };
          jsonls = {
            enable = true;
          };
          # Upstream (fwcd) is deprecated in favour of JetBrains' official
          # kotlin-lsp, which is not packaged in nixpkgs yet. Switch to
          # servers.kotlin_lsp once pkgs.kotlin-lsp lands.
          kotlin_language_server = {
            enable = true;
          };
          lemminx = {
            enable = true;
          };
          marksman = {
            enable = true;
          };
          taplo = {
            enable = true;
          };
          vacuum = {
            enable = true;
          };
          zls = {
            enable = true;
          };
          # vtsls wraps the official VSCode TypeScript language service and
          # has replaced ts_ls as the de-facto standard. Inlay-hint options
          # use the VSCode schema — translated 1:1 from the previous ts_ls
          # includeInlay* flags (the suppress* options invert the old
          # include*WhenMatchesName semantics).
          vtsls =
            let
              inlayHints = {
                parameterNames = {
                  enabled = "all";
                  suppressWhenArgumentMatchesName = false;
                };
                parameterTypes.enabled = true;
                variableTypes = {
                  enabled = true;
                  suppressWhenTypeMatchesName = false;
                };
                propertyDeclarationTypes.enabled = true;
                functionLikeReturnTypes.enabled = true;
                enumMemberValues.enabled = true;
              };
            in
            {
              enable = true;
              extraOptions.settings = {
                typescript.inlayHints = inlayHints;
                javascript.inlayHints = inlayHints;
              };
            };
          eslint = {
            enable = true;
          };
          # Maintained community fork of pyright with extra features and
          # saner defaults; pairs with ruff below the same way pyright did.
          basedpyright = {
            enable = true;
          };
          ruff = {
            enable = true;
          };
          yamlls = {
            enable = true;
          };
          nushell = {
            enable = true;
          };
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            settings = {
              checkOnSave = true;
              check = {
                command = "clippy";
              };
              procMacro = {
                enable = true;
              };
            };
          };
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Goto Definition";
            };
            gr = {
              action = "references";
              desc = "Goto References";
            };
            gD = {
              action = "declaration";
              desc = "Goto Declaration";
            };
            gI = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            gT = {
              action = "type_definition";
              desc = "Type Definition";
            };
            K = {
              action = "hover";
              desc = "Hover";
            };
            "<leader>cw" = {
              action = "workspace_symbol";
              desc = "Workspace Symbol";
            };
            "<leader>cr" = {
              action = "rename";
              desc = "Rename";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Code Action";
            };
          };
          diagnostic = {
            "<leader>cd" = {
              action = "open_float";
              desc = "Line Diagnostics";
            };
            "[d" = {
              action = "goto_prev";
              desc = "Previous Diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Next Diagnostic";
            };
          };
        };
        # nixvim renders `onAttach` as the body of its own LspAttach
        # autocmd callback, with `client` and `bufnr` in scope. Write
        # the body directly — wrapping in `nvim_create_autocmd` nests a
        # second autocmd inside the first, which registers too late to
        # match the attach event it was triggered by and never fires.
        onAttach = ''
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
          end
          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Marksman flags subfolder .md links as "broken" on cold start
          -- (lazy index) — mkdnflow opens them fine, only the diagnostic
          -- is wrong. Silence its diagnostic display on BOTH push and
          -- pull namespaces: marksman advertises `diagnosticProvider`,
          -- so nvim 0.11+ routes diagnostics through pull. Marksman
          -- itself stays fully active for completion / references /
          -- hover; diagnostics remain queryable via vim.diagnostic.get().
          if client.name == "marksman" then
            for _, is_pull in ipairs({ false, true }) do
              local ns = vim.lsp.diagnostic.get_namespace(client.id, is_pull)
              vim.diagnostic.config({
                underline    = false,
                virtual_text = false,
                signs        = false,
              }, ns)
            end
          end
        '';
      };
    };
  };
}
