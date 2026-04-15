{
  lib,
  config,
  ...
}:
{
  imports = [
    ./base16-noctalia.nix
  ];

  options = {
    colorschemes.enable = lib.mkEnableOption "Enable colorschemes module";
  };
  config = lib.mkIf config.colorschemes.enable {
    base16-noctalia.enable = lib.mkDefault true;
  };
}
