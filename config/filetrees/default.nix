{
  lib,
  config,
  ...
}:
{
  imports = [
    ./nvim-tree.nix
  ];

  options = {
    filetrees.enable = lib.mkEnableOption "Enable filetrees module";
  };
  config = lib.mkIf config.filetrees.enable {
    nvim-tree.enable = lib.mkDefault true;
  };
}
