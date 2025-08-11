{ lib, config, ... }:
{
  options = {
    nvim-tree.enable = lib.mkEnableOption "Enable nvim-tree module";
  };
  config = lib.mkIf config.nvim-tree.enable {

    plugins.nvim-tree = {
      enable = true;
      openOnSetupFile = true;
      settings = {
        auto_reload_on_write = true;
        update_focused_file.enable = true;
        renderer = {
          root_folder_label = false;
        };
        view = {
          side = "right";
          width = 50;
        };
      };
    };
  };
}
