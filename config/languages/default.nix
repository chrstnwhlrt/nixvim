{
  lib,
  config,
  ...
}:
{
  imports = [
    ./treesitter-nvim.nix
    ./nvim-jdtls.nix
    ./nvim-lint.nix
    ./mkdnflow.nix
  ];

  options = {
    languages.enable = lib.mkEnableOption "Enable languages module";
  };
  config = lib.mkIf config.languages.enable {
    treesitter-nvim.enable = lib.mkDefault true;
    nvim-jdtls.enable = lib.mkDefault false;
    nvim-lint.enable = lib.mkDefault false;
    mkdnflow.enable = lib.mkDefault true;
  };
}
