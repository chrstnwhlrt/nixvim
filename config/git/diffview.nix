{ lib, config, ... }:
{
  options = {
    diffview.enable = lib.mkEnableOption "Enable diffview module";
  };
  config = lib.mkIf config.diffview.enable {
    plugins.diffview = {
      enable = true;
      settings = {
        hg_cmd = null;
        git_cmd = [ "git" ];
      };
    };
  };
}
