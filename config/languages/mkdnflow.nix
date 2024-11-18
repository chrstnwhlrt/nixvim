{ lib, config, ... }:
{
  options = {
    mkdnflow.enable = lib.mkEnableOption "Enable mkdnflow module";
  };
  config = lib.mkIf config.mkdnflow.enable {
    plugins.mkdnflow = {
      enable = true;
    };
  };
}
