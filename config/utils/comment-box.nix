{ lib, config, ... }:
{
  options = {
    comment-box.enable = lib.mkEnableOption "Enable comment box module";
  };
  config = lib.mkIf config.comment-box.enable {
    plugins.comment-box = {
      enable = true;
    };
  };
}
