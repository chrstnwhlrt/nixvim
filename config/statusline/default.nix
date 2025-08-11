{
  lib,
  config,
  ...
}:
{
  imports = [
    ./lualine.nix
  ];

  options = {
    statusline.enable = lib.mkEnableOption "Enable statusline module";
  };
  config = lib.mkIf config.statusline.enable {
    lualine.enable = lib.mkDefault true;
  };
}
