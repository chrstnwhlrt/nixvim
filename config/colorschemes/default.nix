{
  lib,
  config,
  ...
}:
{
  imports = [
    ./base16.nix
    ./catppuccin.nix
    ./rose-pine.nix
    ./tokyonight.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    base16.enable = lib.mkDefault false;
    catppuccin.enable = lib.mkDefault false;
    rose-pine.enable = lib.mkDefault false;
    tokyonight.enable = lib.mkDefault true;
  };
}
