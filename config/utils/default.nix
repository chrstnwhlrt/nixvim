{
  lib,
  config,
  ...
}:
{
  imports = [
    ./b64.nix
    ./comment.nix
    ./comment-box.nix
    ./harpoon.nix
    ./markdown-preview.nix
    ./mini.nix
    ./nvim-autopairs.nix
    ./nvim-colorizer.nix
    ./nvim-surround.nix
    ./persistence.nix
    ./plenary.nix
    ./todo-comments.nix
    ./undotree.nix
    ./which-key.nix
  ];

  options = {
    utils.enable = lib.mkEnableOption "Enable utils module";
  };
  config = lib.mkIf config.utils.enable {
    b64.enable = lib.mkDefault true;
    comment.enable = lib.mkDefault true;
    comment-box.enable = lib.mkDefault true;
    harpoon.enable = lib.mkDefault true;
    markdown-preview.enable = lib.mkDefault true;
    mini.enable = lib.mkDefault true;
    nvim-autopairs.enable = lib.mkDefault true;
    colorizer.enable = lib.mkDefault true;
    nvim-surround.enable = lib.mkDefault true;
    persistence.enable = lib.mkDefault true;
    plenary.enable = lib.mkDefault true;
    todo-comments.enable = lib.mkDefault true;
    undotree.enable = lib.mkDefault true;
    which-key.enable = lib.mkDefault true;
  };
}
