{
  lib,
  config,
  ...
}:
{
  imports = [
    ./cmp.nix
    ./lspkind.nix
    ./minuet.nix
    ./schemastore.nix
  ];

  options = {
    completion.enable = lib.mkEnableOption "Enable completion module";
  };
  config = lib.mkIf config.completion.enable {
    cmp.enable = lib.mkDefault true;
    lspkind.enable = lib.mkDefault true;
    minuet.enable = lib.mkDefault true;
    schemastore.enable = lib.mkDefault true;
  };
}
