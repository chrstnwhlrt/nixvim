{
  lib,
  config,
  ...
}:
{
  imports = [
    ./set.nix
    ./performance.nix
  ];

  options = {
    sets.enable = lib.mkEnableOption "Enable sets module";
    performance.enable = lib.mkEnableOption "Enable performance module";
  };
  config = lib.mkIf config.utils.enable {
    set.enable = lib.mkDefault true;
    performance.enable = lib.mkDefault true;
  };
}
