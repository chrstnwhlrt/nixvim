{
  lib,
  config,
  ...
}:
{
  imports = [
    ./tokyonight.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    tokyonight.enable = lib.mkDefault true;
  };
}
