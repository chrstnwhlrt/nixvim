{
  lib,
  config,
  ...
}:
{
  options = {
    set.enable = lib.mkEnableOption "Enable set module";
  };
  config = lib.mkIf config.set.enable {
    opts = {
      # Enable relative line numbers
      number = true;
      relativenumber = true;
      clipboard = "unnamedplus";

      tabstop = 4;
      softtabstop = 4;

      # Always show the tabline
      showtabline = 1;
      hidden = true;

      expandtab = true;

      # Enable auto indenting and set it to spaces
      smartindent = true;
      shiftwidth = 4;

      # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
      breakindent = true;

      # Enable incremental searching
      hlsearch = true;
      incsearch = true;

      autochdir = false;

      # Enable text wrap
      wrap = false;

      # Better splitting
      splitbelow = true;
      splitright = true;

      # Enable mouse mode
      mouse = "a"; # Mouse

      # Enable ignorecase + smartcase for better searching
      ignorecase = true;
      smartcase = true; # Don't ignore case with capitals
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      spell = false;

      # Decrease updatetime
      updatetime = 100; # faster completion (4000ms default)

      # Set completeopt to have a better completion experience
      completeopt = [
        "menuone"
        "noselect"
        "noinsert"
      ]; # mostly just for cmp

      # Enable persistent undo history
      swapfile = false;
      backup = false;
      writebackup = false;
      undofile = true;

      # Enable 24-bit colors
      termguicolors = true;

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Enable cursor line highlight
      cursorline = true; # Highlight the line where the cursor is located

      # Set fold settings
      # These options were reccommended by nvim-ufo
      # See: https://github.com/kevinhwang91/nvim-ufo#minimal-configuration
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";

      # Always keep 8 lines above/below cursor unless at start/end of file
      scrolloff = 8;

      showcmd = false;
      ruler = false;

      # Place a column line
      # colorcolumn = "80";

      # Reduce which-key timeout 
      timeoutlen = 200;
      title = true;

      # Set encoding type
      encoding = "utf-8";
      fileencoding = "utf-8";

      # Change cursor options
      # guicursor = [
      #   "n-v-c:block" # Normal, visual, command-line: block cursor
      #   "i-ci-ve:block" # Insert, command-line insert, visual-exclude: vertical bar cursor with block cursor, use "ver25" for 25% width
      #   "r-cr:hor20" # Replace, command-line replace: horizontal bar cursor with 20% height
      #   "o:hor50" # Operator-pending: horizontal bar cursor with 50% height
      #   "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor" # All modes: blinking settings
      #   "sm:block-blinkwait175-blinkoff150-blinkon175" # Showmatch: block cursor with specific blinking settings
      # ];

      # Enable chars list
      # list = true; # Show invisible characters (tabs, eol, ...)
      # listchars = "eol:↲,tab:|->,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣";

      # More space in the neovim command line for displaying messages
      cmdheight = 1;

      showmode = true;

      # Maximum number of items to show in the popup menu (0 means "use available screen space")
      pumheight = 10;

      # Use conform-nvim for gq formatting. ('formatexpr' is set to vim.lsp.formatexpr(), so you can format lines via gq if the language server supports it)
      formatexpr = "v:lua.require'conform'.formatexpr()";

      laststatus = 3; # (https://neovim.io/doc/user/options.html#'laststatus')

      inccommand = "split"; # (https://neovim.io/doc/user/options.html#'inccommand')
    };

    # globals = {
    #   markdown_fenced_languages = "['html', 'python', 'bash=sh', 'javascript', 'typescript', 'zsh=sh', 'yaml', 'json', 'rust', 'typescriptreact', 'css']";
    # };
  };
}
