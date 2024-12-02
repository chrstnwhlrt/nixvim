{ lib, config, ... }:
{
  options = {
    avante.enable = lib.mkEnableOption "Enable avante module";
  };
  config = lib.mkIf config.avante.enable {
    plugins.avante = {
      enable = true;
      settings = {
        provider = "copilot";
      };
    };
  };
}
