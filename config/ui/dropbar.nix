{ lib, config, ... }:
{
  options = {
    dropbar.enable = lib.mkEnableOption "Enable dropbar winbar breadcrumbs";
  };
  config = lib.mkIf config.dropbar.enable {
    # IDE-like winbar breadcrumbs (replaces the archived barbecue.nvim).
    # Needs neither nvim-navic nor lspconfig — sources symbols from LSP,
    # treesitter and markdown headings on its own.
    plugins.dropbar = {
      enable = true;
    };
  };
}
