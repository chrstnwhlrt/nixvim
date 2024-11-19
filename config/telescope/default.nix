{
  lib,
  config,
  ...
}:
{
  imports = [
    ./telescope-nvim.nix
    ./telescope-live-grep-args.nix
  ];

  options = {
    telescope.enable = lib.mkEnableOption "Enable telescope module";
  };
  config = lib.mkIf config.telescope.enable {
    telescope-nvim.enable = lib.mkDefault true;
    telescope-live-grep-args.enable = lib.mkDefault true;
  };
}
