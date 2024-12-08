{ lib, config, ... }:
{
  options = {
    gitsigns.enable = lib.mkEnableOption "Enable gitsigns module";
  };
  config = lib.mkIf config.gitsigns.enable {
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = {
            text = "+";
          };
          change = {
            text = "~";
          };
          delete = {
            text = "_";
          };
          topdelete = {
            text = "‾";
          };
          changedelete = {
            text = "~";
          };
        };
        trouble = true;
        current_line_blame = false;
      };
    };
  };
}
