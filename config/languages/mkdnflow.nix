{ lib, config, ... }:
{
  options = {
    mkdnflow.enable = lib.mkEnableOption "Enable mkdnflow module";
  };
  config = lib.mkIf config.mkdnflow.enable {
    plugins.mkdnflow = {
      enable = true;
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
          MkdnNextLink = [ "n" "<Tab>" ];
          MkdnPrevHeading = [ "n" "[[" ];
          MkdnPrevLink = [ "n" "<S-Tab>" ];
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
