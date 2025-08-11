# Chris nixvim config

Heavily inspired by

-   Neve
-   LunarVim

## Start from nix

```
nix run .
```

## Keybindings

### Leader Key
- **Leader**: `<Space>`

### AI Assistants

#### Minuet AI Completion
Minuet AI is configured for manual triggering to reduce system load:
| Key | Mode | Description |
|-----|------|-------------|
| `<C-g>` | Insert | Trigger Minuet AI completion |
| `<C-y>` | Insert | Accept Minuet completion |
| `<C-Right>` | Insert | Next Minuet completion suggestion |
| `<C-Left>` | Insert | Previous Minuet completion suggestion |
| `<C-x>` | Insert | Clear Minuet completions |

#### Avante AI Assistant (Default Keybindings)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>aa` | Normal/Visual | Ask AI about code |
| `<leader>ae` | Normal | Edit with AI |
| `<leader>ar` | Normal | Refresh AI response |
| `<leader>af` | Normal | Focus AI sidebar |

### Code Completion (cmp)
| Key | Mode | Description |
|-----|------|-------------|
| `<C-j>` / `<C-n>` | Insert | Select next completion item |
| `<C-k>` / `<C-p>` | Insert | Select previous completion item |
| `<Tab>` | Insert/Select | Smart next/expand snippet |
| `<S-Tab>` | Insert/Select | Smart previous/jump back |
| `<C-e>` | Insert | Abort completion |
| `<C-f>` | Insert | Scroll docs down |
| `<C-b>` | Insert | Scroll docs up |
| `<C-Space>` | Insert | Show completion menu |
| `<CR>` | Insert | Confirm selection |
| `<S-CR>` | Insert | Confirm with replace |

### Window Management
| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | Normal | Go to left window |
| `<C-j>` | Normal | Go to lower window |
| `<C-k>` | Normal | Go to upper window |
| `<C-l>` | Normal | Go to right window |
| `<leader>ww` | Normal | Switch to other window |
| `<leader>wd` | Normal | Delete window |
| `<leader>w-` | Normal | Split window below |
| `<leader>w\|` | Normal | Split window right |

### Buffer Management
| Key | Mode | Description |
|-----|------|-------------|
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Previous buffer |
| `<leader>bd` | Normal | Delete buffer |
| `<leader>bb` | Normal | Switch to other buffer |
| `<leader>bo` | Normal | Close other buffers |
| `<leader>bp` | Normal | Toggle pin |
| `<leader>bP` | Normal | Delete non-pinned buffers |

### File Navigation (Telescope)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | Normal | Find files |
| `<leader>fr` | Normal | Recent files |
| `<leader>fb` | Normal | Buffers |
| `<leader>fa` | Normal | Live grep with args |
| `<leader>ft` | Normal | Live grep |
| `<C-p>` | Normal | Git files |
| `<leader>gc` | Normal | Git commits |
| `<leader>gs` | Normal | Git status |

### Search (Telescope)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sa` | Normal | Auto commands |
| `<leader>sb` | Normal | Current buffer fuzzy find |
| `<leader>sc` | Normal | Command history |
| `<leader>sC` | Normal | Commands |
| `<leader>sd` | Normal | Document diagnostics |
| `<leader>sD` | Normal | Workspace diagnostics |
| `<leader>sh` | Normal | Help pages |
| `<leader>sH` | Normal | Highlight groups |
| `<leader>sk` | Normal | Keymaps |
| `<leader>sM` | Normal | Man pages |
| `<leader>sm` | Normal | Jump to marks |
| `<leader>so` | Normal | Vim options |
| `<leader>sR` | Normal | Resume last search |
| `<leader>st` | Normal | Todo comments |
| `<leader>:` | Normal | Command history |
| `<leader>uC` | Normal | Colorscheme preview |

### LSP & Code Actions
| Key | Mode | Description |
|-----|------|-------------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | Go to references |
| `gD` | Normal | Go to declaration |
| `gI` | Normal | Go to implementation |
| `gT` | Normal | Go to type definition |
| `K` | Normal | Hover documentation |
| `[d` | Normal | Previous diagnostic |
| `]d` | Normal | Next diagnostic |
| `<leader>cw` | Normal | Workspace symbol |
| `<leader>cr` | Normal | Rename |
| `<leader>ca` | Normal | Code action |
| `<leader>cd` | Normal | Line diagnostics |
| `<leader>cf` | Normal | Format buffer |
| `<leader>cF` | Visual | Format selection |
| `<leader>uf` | Normal | Toggle auto-format (buffer) |
| `<leader>uF` | Normal | Toggle auto-format (global) |

### Diagnostics (Trouble)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>x` | Normal | Diagnostics toggle |
| `<leader>xx` | Normal | Buffer diagnostics |
| `<leader>xX` | Normal | Workspace diagnostics |
| `<leader>xt` | Normal | Todo list |
| `<leader>xQ` | Normal | Quickfix list |

### Debugging (DAP)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>dB` | Normal | Breakpoint condition |
| `<leader>db` | Normal | Toggle breakpoint |
| `<leader>dc` / `<leader>da` | Normal | Continue |
| `<leader>dC` | Normal | Run to cursor |
| `<leader>dg` | Normal | Go to line (no execute) |
| `<leader>di` | Normal | Step into |
| `<leader>dj` | Normal | Down in stack |
| `<leader>dk` | Normal | Up in stack |
| `<leader>dl` | Normal | Run last |
| `<leader>do` | Normal | Step out |
| `<leader>dO` | Normal | Step over |
| `<leader>dp` | Normal | Pause |
| `<leader>dr` | Normal | Toggle REPL |
| `<leader>ds` | Normal | Session |
| `<leader>dt` | Normal | Terminate |
| `<leader>du` | Normal | DAP UI |
| `<leader>dw` | Normal | Widgets |
| `<leader>de` | Normal/Visual | Evaluate |

### Harpoon (Quick Navigation)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ha` | Normal | Add file to Harpoon |
| `<C-e>` | Normal | Toggle Harpoon menu ⚠️ Conflicts with cmp abort |
| `<leader>hj` | Normal | Navigate to file 1 |
| `<leader>hk` | Normal | Navigate to file 2 |
| `<leader>hl` | Normal | Navigate to file 3 |
| `<leader>hm` | Normal | Navigate to file 4 |

### Git (Gitsigns - Default Keybindings)
| Key | Mode | Description |
|-----|------|-------------|
| `]c` | Normal | Next hunk |
| `[c` | Normal | Previous hunk |
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hu` | Normal | Undo stage hunk |
| `<leader>hR` | Normal | Reset buffer |
| `<leader>hp` | Normal | Preview hunk |
| `<leader>hb` | Normal | Blame line |
| `<leader>tb` | Normal | Toggle current line blame |
| `<leader>hd` | Normal | Diff this |
| `<leader>hD` | Normal | Diff this ~ |
| `<leader>td` | Normal | Toggle deleted |
| `ih` | Operator/Visual | Select hunk |

### Text Manipulation

#### Surround (nvim-surround - Default Keybindings)
| Key | Mode | Description |
|-----|------|-------------|
| `ys{motion}{char}` | Normal | Add surrounding |
| `yss{char}` | Normal | Surround line |
| `yS{motion}{char}` | Normal | Add surrounding on new line |
| `ySS{char}` | Normal | Surround line on new line |
| `ds{char}` | Normal | Delete surrounding |
| `cs{old}{new}` | Normal | Change surrounding |
| `S{char}` | Visual | Surround selection |
| `gS{char}` | Visual | Surround selection on new lines |

#### Comments (comment.nvim - Default Keybindings)
| Key | Mode | Description |
|-----|------|-------------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc{motion}` | Normal | Toggle comment over motion |
| `gb{motion}` | Normal | Toggle block comment over motion |
| `gc` | Visual | Toggle line comment |
| `gb` | Visual | Toggle block comment |

#### TreeSitter
| Key | Mode | Description |
|-----|------|-------------|
| `<C-space>` | Normal | Init selection/Node incremental |
| `<BS>` | Visual | Node decremental |
| `]m` | Normal | Next function start |
| `]]` | Normal | Next class start |
| `]M` | Normal | Next function end |
| `][` | Normal | Next class end |
| `[m` | Normal | Previous function start |
| `[[` | Normal | Previous class start |
| `[M` | Normal | Previous function end |
| `[]` | Normal | Previous class end |

#### Text Objects (TreeSitter & mini.ai)
| Key | Mode | Description |
|-----|------|-------------|
| `aa`/`ia` | Operator/Visual | Around/inside parameter |
| `af`/`if` | Operator/Visual | Around/inside function |
| `ac`/`ic` | Operator/Visual | Around/inside class |
| `ai`/`ii` | Operator/Visual | Around/inside conditional |
| `al`/`il` | Operator/Visual | Around/inside loop |
| `at` | Operator/Visual | Around comment |
| `a)`/`i)`, `a]`/`i]`, `a}`/`i}` | Operator/Visual | Around/inside brackets |
| `a'`/`i'`, `a"`/`i"` | Operator/Visual | Around/inside quotes |

### Markdown (mkdnflow)
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>p` | Normal/Visual | Create link from clipboard |
| `<CR>` | Normal/Visual/Insert | Follow/create link |
| `<BS>` | Normal | Go back |
| `<Del>` | Normal | Go forward |
| `<M-CR>` | Normal | Destroy link |
| `<Tab>` | Normal/Insert | Next link |
| `<S-Tab>` | Normal/Insert | Previous link |
| `+` | Normal | Increase heading |
| `-` | Normal | Decrease heading |
| `]]` | Normal | Next heading ⚠️ Conflicts with TreeSitter |
| `[[` | Normal | Previous heading ⚠️ Conflicts with TreeSitter |
| `o` | Normal | New list item below |
| `O` | Normal | New list item above |
| `<C-Space>` | Normal/Visual | Toggle todo ⚠️ Conflicts with cmp/TreeSitter |
| `<F2>` | Normal | Move source |
| `<leader>f` | Normal | Fold section |
| `<leader>F` | Normal | Unfold section |
| `<leader>nn` | Normal | Update numbering |
| `ya` | Normal | Yank anchor link |
| `yfa` | Normal | Yank file anchor link |
| `<leader>ic`/`<leader>iC` | Normal | Insert column after/before |
| `<leader>ir`/`<leader>iR` | Normal | Insert row below/above |
| `<M-CR>` | Insert | Previous row (in tables) |

### Utilities
| Key | Mode | Description |
|-----|------|-------------|
| `<C-s>` | Normal | Save file |
| `<C-d>` | Normal | Half page down (centered) |
| `<C-u>` | Normal | Half page up (centered) |
| `<Esc>` | Normal | Clear search highlight |
| `<leader>e` | Normal | Toggle file tree (nvim-tree) |
| `<leader>qq` | Normal | Quit all |
| `<leader>uh` | Normal | Toggle inlay hints |
| `<leader>ut` | Normal | Toggle undo tree |
| `<leader>cp` | Normal | Preview markdown |
| `<leader>be` | Visual | Encode base64 |
| `<leader>bd` | Visual | Decode base64 |

### Copy/Paste/Delete
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>p` | Visual | Paste without yanking deleted text ⚠️ Conflicts with mkdnflow |
| `<leader>y` | Normal/Visual | Copy to system clipboard |
| `<leader>Y` | Normal/Visual | Copy line to system clipboard |
| `<leader>D` | Normal/Visual | Delete to void register |

### Visual Mode
| Key | Mode | Description |
|-----|------|-------------|
| `<` | Visual | Unindent and stay in visual mode |
| `>` | Visual | Indent and stay in visual mode |

### Potential Conflicts
⚠️ **Note**: Some keybindings have conflicts but work in different modes:
- `<C-e>`: Harpoon menu (Normal) vs CMP abort (Insert)
- `<C-Space>`: CMP complete (Insert) vs TreeSitter selection (Normal) vs mkdnflow todo (Normal)
- `<leader>p`: Paste without yank (Visual) vs mkdnflow create link (Normal/Visual)
- `]]`/`[[`: TreeSitter class navigation vs mkdnflow heading navigation
- `<Tab>`: Buffer navigation (Normal) vs CMP/snippet expansion (Insert) vs mkdnflow link navigation

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
