{ lib, config, ... }:
{
  options = {
    blink-cmp.enable = lib.mkEnableOption "Enable blink-cmp module";
  };
  config = lib.mkIf config.blink-cmp.enable {
    plugins.blink-cmp = {
      enable = true;
      symbolMap = {
        Copilot = "";
      };
      extraOptions = {
        maxwidth = 50;
        ellipsis_char = "...";
      };
    };
  };
}
