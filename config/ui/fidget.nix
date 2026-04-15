{ lib, config, ... }:
{
  options = {
    fidget.enable = lib.mkEnableOption "Enable fidget.nvim LSP progress UI";
  };
  config = lib.mkIf config.fidget.enable {
    plugins.fidget = {
      enable = true;
      settings = {
        progress = {
          display = {
            done_icon = "✓";
            progress_icon.pattern = "dots";
          };
        };
        notification = {
          window = {
            winblend = 0;
            border = "rounded";
          };
        };
      };
    };
  };
}
