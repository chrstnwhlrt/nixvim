# Thanks for the keybinds primeagen and folke!
{ lib, config, ... }:
{
  options = {
    keys.enable = lib.mkEnableOption "Enable keys module";
  };
  config = lib.mkIf config.keys.enable {
    globals.mapleader = " ";
    keymaps = [

      # Windows
      {
        mode = "n";
        key = "<leader>ww";
        action = "<C-W>p";
        options = {
          silent = true;
          desc = "Other window";
        };
      }

      {
        mode = "n";
        key = "<leader>wd";
        action = "<C-W>c";
        options = {
          silent = true;
          desc = "Delete window";
        };
      }

      {
        mode = "n";
        key = "<leader>w-";
        action = "<C-W>s";
        options = {
          silent = true;
          desc = "Split window below";
        };
      }

      {
        mode = "n";
        key = "<leader>w|";
        action = "<C-W>v";
        options = {
          silent = true;
          desc = "Split window right";
        };
      }
      
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-W>h";
        options = {
          silent = true;
          desc = "Go to the left window";
        };
      }

      {
        mode = "n";
        key = "<C-j>";
        action = "<C-W>j";
        options = {
          silent = true;
          desc = "Go to the lower window";
        };
      }

      {
        mode = "n";
        key = "<C-k>";
        action = "<C-W>k";
        options = {
          silent = true;
          desc = "Go to the upper window";
        };
      }

      {
        mode = "n";
        key = "<C-l>";
        action = "<C-W>l";
        options = {
          silent = true;
          desc = "Go to the right window";
        };
      }

      {
        mode = "n";
        key = "<C-s>";
        action = "<cmd>w<cr><esc>";
        options = {
          silent = true;
          desc = "Save file";
        };
      }

      # Quit/Session
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>quitall<cr><esc>";
        options = {
          silent = true;
          desc = "Quit all";
        };
      }

      {
        mode = "n";
        key = "<leader>qs";
        action = ":lua require('persistence').load()<cr>";
        options = {
          silent = true;
          desc = "Restore session";
        };
      }

      {
        mode = "n";
        key = "<leader>ql";
        action = "<cmd>lua require('persistence').load({ last = true })<cr>";
        options = {
          silent = true;
          desc = "Restore last session";
        };
      }

      {
        mode = "n";
        key = "<leader>qd";
        action = "<cmd>lua require('persistence').stop()<cr>";
        options = {
          silent = true;
          desc = "Don't save current session";
        };
      }

      # Inlay Hints
      {
        mode = "n";
        key = "<leader>uh";
        action = ":lua ToggleInlayHints()<cr>";
        options = {
          silent = true;
          desc = "Toggle Inlay Hints";
        };
      }

      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move up when line is highlighted";
        };
      }

      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options = {
          silent = true;
          desc = "Move down when line is highlighted";
        };
      }

      {
        mode = "n";
        key = "J";
        action = "mzJ`z";
        options = {
          silent = true;
          desc = "Allow cursor to stay in the same place after appeding to current line";
        };
      }

      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          silent = true;
          desc = "Indent while remaining in visual mode.";
        };
      }

      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          silent = true;
          desc = "Indent while remaining in visual mode.";
        };
      }

      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options = {
          silent = true;
          desc = "Allow <C-d> and <C-u> to keep the cursor in the middle";
        };
      }

      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options = {
          desc = "Allow C-d and C-u to keep the cursor in the middle";
        };
      }

      # Remap for dealing with word wrap and adding jumps to the jumplist.
      {
        mode = "n";
        key = "j";
        action.__raw = "
        [[(v:count > 1 ? 'm`' . v:count : 'g') . 'j']]
      ";
        options = {
          expr = true;
          desc = "Remap for dealing with word wrap and adding jumps to the jumplist.";
        };
      }

      {
        mode = "n";
        key = "k";
        action.__raw = "
        [[(v:count > 1 ? 'm`' . v:count : 'g') . 'k']]
      ";
        options = {
          expr = true;
          desc = "Remap for dealing with word wrap and adding jumps to the jumplist.";
        };
      }

      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options = {
          desc = "Allow search terms to stay in the middle";
        };
      }

      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options = {
          desc = "Allow search terms to stay in the middle";
        };
      }

      # Paste stuff without saving the deleted word into the buffer
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
        options = {
          desc = "Deletes to void register and paste over";
        };
      }

      # Copy stuff to system clipboard with <leader> + y or just y to have it just in vim
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>y";
        action = "\"+y";
        options = {
          desc = "Copy to system clipboard";
        };
      }

      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>Y";
        action = "\"+Y";
        options = {
          desc = "Copy to system clipboard";
        };
      }

      # Delete to void register
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>D";
        action = "\"_d";
        options = {
          desc = "Delete to void register";
        };
      }

      # <C-c> instead of pressing esc just because
      # {
      #   mode = "i";
      #   key = "<C-c>";
      #   action = "<Esc>";
      # }

      # {
      #   mode = "n";
      #   key = "<C-f>";
      #   action = "!tmux new tmux-sessionizer<CR>";
      #   options = {
      #     desc = "Switch between projects";
      #   };
      # }

      # Set highlight on search, but clear on pressing <Esc> in normal mode
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }

      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<cr>";
        options = {
          silent = true;
          desc = "Open nvim-tree";
        };
      }
    ];
  };
}
