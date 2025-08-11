{
  lib,
  config,
  ...
}:
{
  imports = [
    ./treesitter-nvim.nix
    ./mkdnflow.nix
  ];

  options = {
    languages.enable = lib.mkEnableOption "Enable languages module";
  };
  config = lib.mkIf config.languages.enable {
    treesitter-nvim.enable = lib.mkDefault true;
    mkdnflow.enable = lib.mkDefault true;
  };
}
