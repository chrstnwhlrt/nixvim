{
  lib,
  config,
  ...
}:
{
  options = {
    perf.enable = lib.mkEnableOption "Enable performance module";
  };
  config = lib.mkIf config.perf.enable {
    performance = {
      byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };
      combinePlugins = {
        enable = false;
        standalonePlugins = [
          "nvim-treesitter"
          "mini"
        ];
      };
    };
  };
}
