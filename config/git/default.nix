{
  lib,
  config,
  ...
}:
{
  imports = [
    ./diffview.nix
    ./gitsigns.nix
  ];

  options = {
    git.enable = lib.mkEnableOption "Enable git module";
  };
  config = lib.mkIf config.git.enable {
    diffview.enable = lib.mkDefault true;
    gitsigns.enable = lib.mkDefault true;
  };
}
