{ lib, config, pkgs, ... }:
{
  options = {
    diffview.enable = lib.mkEnableOption "Enable diffview module";
  };
  config = lib.mkIf config.diffview.enable {
    plugins.diffview = {
      enable = true;
      # Upstream sindrets/diffview.nvim has been unmaintained since
      # 2024-08; pin the actively maintained drop-in fork instead
      # (same lua module name, so nixvim's setup call keeps working).
      package = pkgs.vimUtils.buildVimPlugin {
        pname = "diffview-plus.nvim";
        version = "2026-06-12";
        src = pkgs.fetchFromGitHub {
          owner = "dlyongemallo";
          repo = "diffview-plus.nvim";
          rev = "1551fc496c29e14ebd4cf04543549a59dfe5d0dc";
          hash = "sha256-6U+Fn/8s8ODRevyXTSFAd753QgkExORk+T9lNF+t5HE=";
        };
        dependencies = [ pkgs.vimPlugins.plenary-nvim ];
        # require-check derives "diffview-plus" from pname; the lua
        # module is still called "diffview".
        nvimRequireCheck = "diffview";
      };
      settings = {
        hg_cmd = null;
        git_cmd = [ "git" ];
      };
    };
  };
}
