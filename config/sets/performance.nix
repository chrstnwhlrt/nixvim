{
  lib,
  config,
  ...
}:
{
  options = {
    performance.enable = lib.mkEnableOption "Enable performance module";
  };
  config = lib.mkIf config.performance.enable {
    options.performance = {
      byteCompileLua = {
        enable = true;
        bla = false;
      };
    };
  };
}
