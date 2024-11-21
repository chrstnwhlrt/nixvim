{
  lib,
  config,
  ...
}:
{
  imports = [
    ./better-escape.nix
    ./cloak.nix
    ./comment.nix
    ./comment-box.nix
    ./harpoon.nix
    ./markdown-preview.nix
    ./mini.nix
    ./neocord.nix
    ./neotest.nix
    ./nvim-autopairs.nix
    ./nvim-colorizer.nix
    ./nvim-surround.nix
    ./nvterm.nix
    ./oil.nix
    ./persistence.nix
    ./plenary.nix
    ./project-nvim.nix
    ./sidebar.nix
    ./tmux-navigator.nix
    ./todo-comments.nix
    ./ultimate-autopair.nix
    ./undotree.nix
    ./wakatime.nix
    ./which-key.nix
    ./wilder.nix
  ];

  options = {
    utils.enable = lib.mkEnableOption "Enable utils module";
  };
  config = lib.mkIf config.utils.enable {
    better-escape.enable = lib.mkDefault false;
    cloak.enable = lib.mkDefault false;
    comment.enable = lib.mkDefault true;
    comment-box.enable = lib.mkDefault true;
    harpoon.enable = lib.mkDefault true;
    markdown-preview.enable = lib.mkDefault true;
    mini.enable = lib.mkDefault true;
    neocord.enable = lib.mkDefault false;
    neotest.enable = lib.mkDefault false;
    nvim-autopairs.enable = lib.mkDefault true;
    nvim-colorizer.enable = lib.mkDefault true;
    nvim-surround.enable = lib.mkDefault true;
    nvterm.enable = lib.mkDefault false;
    oil.enable = lib.mkDefault false;
    persistence.enable = lib.mkDefault true;
    plenary.enable = lib.mkDefault true;
    project-nvim.enable = lib.mkDefault false;
    sidebar.enable = lib.mkDefault false;
    tmux-navigator.enable = lib.mkDefault false;
    todo-comments.enable = lib.mkDefault true;
    ultimate-autopair.enable = lib.mkDefault true;
    undotree.enable = lib.mkDefault true;
    wakatime.enable = lib.mkDefault false;
    which-key.enable = lib.mkDefault true;
    wilder.enable = lib.mkDefault false;
  };
}
