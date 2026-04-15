{
  lib,
  config,
  ...
}:
{
  imports = [
    ./blink-cmp.nix
    ./minuet.nix
    ./schemastore.nix
  ];

  options = {
    completion.enable = lib.mkEnableOption "Enable completion module";
  };
  config = lib.mkIf config.completion.enable {
    blink-cmp.enable = lib.mkDefault true;
    minuet.enable = lib.mkDefault true;
    schemastore.enable = lib.mkDefault true;
  };
}
