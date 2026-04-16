{ lib, config, ... }:
{
  options = {
    barbecue.enable = lib.mkEnableOption "Enable barbecue module";
  };
  config = lib.mkIf config.barbecue.enable {
    plugins.barbecue = {
      enable = true;
      settings = {
        theme = "auto";
      };
    };
  };
}
