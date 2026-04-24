{ lib, config, ... }:
{
  options = {
    mkdnflow.enable = lib.mkEnableOption "Enable mkdnflow module";
  };
  config = lib.mkIf config.mkdnflow.enable {
    plugins.mkdnflow = {
      enable = true;
      # Resolve relative links from the CURRENT file's directory, not
      # from the first markdown file opened in the session (mkdnflow's
      # "first" default). Matches standard markdown-renderer / browser
      # behaviour: `[x](sub/y.md)` in `a/b.md` points at `a/b/sub/y.md`.
      settings.perspective.priority = "current";
      settings.mappings = {
          MkdnCreateLink = false;
          MkdnCreateLinkFromClipboard = [ [ "n" "v" ] "<leader>p" ];
          MkdnDecreaseHeading = [ "n" "-" ];
          MkdnDestroyLink = [ "n" "<M-CR>" ];
          MkdnEnter = [ [ "n" "v" "i" ] "<CR>" ];
          MkdnExtendList = false;
          MkdnFoldSection = [ "n" "<leader>f" ];
          MkdnFollowLink = false;
          MkdnGoBack = [ "n" "<BS>" ];
          MkdnGoForward = [ "n" "<Del>" ];
          MkdnIncreaseHeading = [ "n" "+" ];
          MkdnMoveSource = [ "n" "<F2>" ];
          MkdnNewListItemAboveInsert = [ "n" "O" ];
          MkdnNewListItemBelowInsert = [ "n" "o" ];
          MkdnNextHeading = [ "n" "]]" ];
          MkdnNextLink = false; # free <Tab> for BufferLineCycleNext in markdown
          MkdnPrevHeading = [ "n" "[[" ];
          MkdnPrevLink = false; # free <S-Tab> for BufferLineCyclePrev in markdown
          MkdnSTab = false;
          MkdnTab = false;
          MkdnTableNewColAfter = [ "n" "<leader>ic" ];
          MkdnTableNewColBefore = [ "n" "<leader>iC" ];
          MkdnTableNewRowAbove = [ "n" "<leader>iR" ];
          MkdnTableNewRowBelow = [ "n" "<leader>ir" ];
          MkdnTableNextCell = [ "i" "<Tab>" ];
          MkdnTableNextRow = false;
          MkdnTablePrevCell = [ "i" "<S-Tab>" ];
          MkdnTablePrevRow = [ "i" "<M-CR>" ];
          MkdnToggleToDo = [ [ "n" "v" ] "<C-Space>" ];
          MkdnUnfoldSection = [ "n" "<leader>F" ];
          MkdnUpdateNumbering = [ "n" "<leader>nn" ];
          MkdnYankAnchorLink = [ "n" "ya" ];
          MkdnYankFileAnchorLink = [ "n" "yfa" ];
        };
    };
  };
}
