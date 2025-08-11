{
  lib,
  config,
  ...
}:
{
  imports = [
    ./alpha.nix
    ./barbecue.nix
    ./dressing-nvim.nix
    ./indent-blankline.nix
    ./noice.nix
    ./nui.nix
    ./web-devicons.nix
    ./snacks.nix
  ];

  options = {
    ui.enable = lib.mkEnableOption "Enable ui module";
  };
  config = lib.mkIf config.ui.enable {
    alpha.enable = lib.mkDefault true;
    barbecue.enable = lib.mkDefault true;
    dressing-nvim.enable = lib.mkDefault true;
    indent-blankline.enable = lib.mkDefault true;
    noice.enable = lib.mkDefault true;
    nui.enable = lib.mkDefault true;
    web-devicons.enable = lib.mkDefault true;
    snacks.enable = lib.mkDefault true;
  };
}
