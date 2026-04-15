{
  lib,
  config,
  ...
}:
{
  imports = [
    ./barbecue.nix
    ./fidget.nix
    ./snacks.nix
    ./snacks-picker-keys.nix
    ./web-devicons.nix
  ];

  options = {
    ui.enable = lib.mkEnableOption "Enable ui module";
  };
  config = lib.mkIf config.ui.enable {
    barbecue.enable = lib.mkDefault true;
    fidget.enable = lib.mkDefault true;
    snacks.enable = lib.mkDefault true;
    snacks-picker-keys.enable = lib.mkDefault true;
    web-devicons.enable = lib.mkDefault true;
  };
}
