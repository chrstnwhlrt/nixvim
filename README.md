# Chris nixvim config

Heavily inspired by

-   Neve
-   LunarVim

## Start from nix

```
nix run .
```

## Plugins

This NixVim configuration includes 45+ plugins organized into the following categories:

### Bufferlines
- **bufferline** - Buffer line display with tabs and diagnostics integration

### Colorschemes
- **tokyonight** - Tokyo Night colorscheme with transparent background

### Completion
- **cmp** - Main completion engine with multiple sources
- **cmp-nvim-lsp** - LSP completion source
- **cmp-buffer** - Buffer completion source
- **cmp-path** - File path completion source
- **cmp-cmdline** - Command line completion source
- **cmp_luasnip** - LuaSnip completion source
- **lspkind** - LSP symbol kinds with icons
- **minuet** - AI-powered code completion with Ollama (qwen3-coder model)
- **schemastore** - JSON/YAML schema validation

### DAP (Debug Adapter Protocol)
- **dap** - Debug adapter protocol support with breakpoint signs

### File Trees
- **nvim-tree** - File explorer with auto-reload and focus features

### Git Integration
- **diffview** - Git diff viewer with customizable commands
- **gitsigns** - Git status signs in the gutter

### Languages
- **mkdnflow** - Markdown workflow tools with link creation and navigation
- **treesitter** - Syntax highlighting and parsing with extensive language support

### LSP (Language Server Protocol)
- **conform-nvim** - Code formatting with multiple formatter support
- **lsp** - Core LSP configuration with 20+ language servers
- **trouble** - Diagnostics and quickfix list enhancement

### Snippets
- **luasnip** - Snippet engine with autosnippets support

### Statusline
- **lualine** - Statusline with extensive configuration and theming

### Telescope
- **telescope** - Fuzzy finder with fzf-native extension
- **telescope-live-grep-args** - Enhanced live grep functionality

### UI Enhancements
- **alpha** - Start screen with custom layout
- **barbecue** - Breadcrumb navigation in winbar
- **dressing-nvim** - Enhanced vim.ui.select and vim.ui.input interfaces
- **indent-blankline** - Indentation guides with scope highlighting
- **noice** - UI enhancement for messages, cmdline, and popupmenu
- **nui-nvim** - UI component library
- **snacks** - UI utility collection with dashboard features
- **web-devicons** - File type icons support

### Utilities
- **avante** - AI-powered coding assistant with Ollama (qwen3-coder model)
- **b64** - Base64 encoding/decoding functionality
- **comment** - Commenting functionality
- **comment-box** - Comment box creation and formatting
- **colorizer** - Color code highlighting
- **harpoon** - File navigation and management with telescope integration
- **markdown-preview** - Markdown live preview
- **mini** - Mini.nvim modules collection
- **nvim-autopairs** - Automatic bracket/quote pairing
- **nvim-surround** - Text surrounding operations
- **plenary-nvim** - Lua utility library (dependency for other plugins)
- **todo-comments** - TODO/FIXME/HACK comment highlighting
- **undotree** - Undo tree visualization with auto-diff
- **which-key** - Keybinding help and discovery
