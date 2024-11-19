{ lib, config, ... }:
{
  options = {
    comment.enable = lib.mkEnableOption "Enable comment module";
  };
  config = lib.mkIf config.comment.enable {
    plugins.comment = {
      enable = true;
    };
  };
}
