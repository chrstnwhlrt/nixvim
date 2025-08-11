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
  };
  config = lib.mkIf config.sets.enable {
    set.enable = lib.mkDefault true;
    perf.enable = lib.mkDefault true;
  };
}
