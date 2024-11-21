{ lib, config, ... }:
{
  options = {
    nvim-tree.enable = lib.mkEnableOption "Enable nvim-tree module";
  };
  config = lib.mkIf config.nvim-tree.enable {

    plugins.nvim-tree = {
      enable = true;
      openOnSetupFile = true;
      autoReloadOnWrite = true;
    };
  };
}
