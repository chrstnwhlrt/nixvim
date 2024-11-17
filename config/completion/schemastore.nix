{ lib, config, ... }:
{
  options = {
    schemastore.enable = lib.mkEnableOption "Enable schemastore module";
  };
  config = lib.mkIf config.schemastore.enable {
    plugins.schemastore = {
        enable = true;
        yaml.enable = true;
        json.enable = true;
    };
  };
}
