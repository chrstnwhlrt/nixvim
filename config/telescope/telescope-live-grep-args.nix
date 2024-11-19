{
  lib,
  config,
  ...
}:
{
  options = {
    telescope-live-grep-args.enable = lib.mkEnableOption "Enable the live grep args telescope extension module";
  };
  config = lib.mkIf config.telescope-live-grep-args.enable {
    plugins.telescope.extensions.live-grep-args = {
      enable = true;
    };
  };
}
