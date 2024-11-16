{ lib, config, ... }:
{
  options = {
    tokyonight.enable = lib.mkEnableOption "Enable tokyonight module";
  };
  config = lib.mkIf config.tokyonight.enable {
    colorschemes = {
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
          styles = {
            floats = "transparent";
            sidebars = "transparent";
          };
        };
      };
    };
  };
}
