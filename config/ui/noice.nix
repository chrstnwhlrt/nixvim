{ lib, config, ... }:
{
  options = {
    noice.enable = lib.mkEnableOption "Enable noice module";
  };
  config = lib.mkIf config.noice.enable {
    plugins.noice = {
      enable = true;
      settings = {
        notify = {
          enabled = true;
        };
        messages = {
          enabled = true; # Adds a padding-bottom to neovim statusline when set to false for some reason
          viewHistory = "messages";
          viewSearch = "virtualtext";
        };
        lsp = {
          message = {
            enabled = true;
          };
          progress = {
            enabled = false;
          };
        };
        popupmenu = {
          enabled = true;
          backend = "nui";
        };
        format = {
          filter = {
            pattern = [
              ":%s*%%s*s:%s*"
              ":%s*%%s*s!%s*"
              ":%s*%%s*s/%s*"
              "%s*s:%s*"
              ":%s*s!%s*"
              ":%s*s/%s*"
            ];
            icon = "";
            lang = "regex";
          };
          replace = {
            pattern = [
              ":%s*%%s*s:%w*:%s*"
              ":%s*%%s*s!%w*!%s*"
              ":%s*%%s*s/%w*/%s*"
              "%s*s:%w*:%s*"
              ":%s*s!%w*!%s*"
              ":%s*s/%w*/%s*"
            ];
            icon = "󱞪";
            lang = "regex";
          };
        };
      };
    };
  };
}
