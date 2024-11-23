{ lib, config, ... }:
{
  options = {
    copilot-chat.enable = lib.mkEnableOption "Enable copilot-chat module";
  };
  config = lib.mkIf config.copilot-chat.enable {
    plugins.copilot-chat = {
      enable = true;
    };
  };
}
