{
  lib,
  config,
  ...
}:
{
  imports = [
    ./cmp.nix
    ./blink-cmp.nix
    ./copilot.nix
    ./copilot-chat.nix
    ./lspkind.nix
    ./schemastore.nix
    ./avante.nix
  ];

  options = {
    completion.enable = lib.mkEnableOption "Enable completion module";
  };
  config = lib.mkIf config.completion.enable {
    cmp.enable = lib.mkDefault true;
    blink-cmp.enable = lib.mkDefault false;
    copilot.enable = lib.mkDefault true;
    copilot-chat.enable = lib.mkDefault false;
    lspkind.enable = lib.mkDefault true;
    schemastore.enable = lib.mkDefault true;
    avante.enable = lib.mkDefault true;
  };
}
