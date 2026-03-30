{
  lib,
  config,
  ...
}:
{
  imports = [
    ./tokyonight.nix
    ./base16-noctalia.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    tokyonight.enable = lib.mkDefault true;
    base16-noctalia.enable = lib.mkDefault true;
  };
}
