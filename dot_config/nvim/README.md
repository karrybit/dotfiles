# Neovim Configuration

Quick reference for this personal Neovim configuration. `<leader>` is the Space
key. Standard Vim commands are intentionally omitted.

## Basic Operations

| Key | Action |
| --- | --- |
| `<leader>w` | Save the current file |
| `<leader>q` | Close the current window |
| `<leader>bd` | Delete the current buffer while preserving the window layout |
| `jj` | Leave Insert mode |
| `<Esc><Esc>` | Clear search highlights |
| `[b` / `]b` | Go to the previous or next buffer |
| `<C-n><C-n>` | Leave Terminal mode |

In Visual mode, `y` moves the cursor to the end of the selection after yanking.
Using `p` does not overwrite the register containing the pasted text.

## Snacks

| Key | Action |
| --- | --- |
| `<leader>e` | Open the file explorer |
| `<leader>E` | Reveal the current file in the explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Search text |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Search help |
| `<leader>fr` | Find recently opened files |
| `<leader>o` | Find symbols in the current document |
| `<leader>s` | Find symbols in the workspace |
| `<leader>t` | Toggle the terminal |

Use `<leader>bd` to close an open file while keeping the explorer and editor
window layout intact.

The following keys are available inside the explorer:

| Key | Action |
| --- | --- |
| `l` | Open a file or expand a directory |
| `h` | Collapse a directory |
| `<BS>` | Go to the parent directory |
| `a` / `d` / `r` | Add, delete, or rename a file |
| `c` / `m` | Copy or move a file |
| `H` / `I` | Toggle hidden or ignored files |

## LSP

The following keys are available in buffers with an attached LSP server:

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | Find references |
| `K` | Show hover documentation |
| `[g` / `]g` | Go to the previous or next diagnostic |
| `<leader>d` | Show diagnostics |
| `<leader>rn` | Rename a symbol |
| `<leader>a` | Show code actions |
| `<leader>f` | Format the current buffer |

Mason automatically installs `lua_ls`, `rust_analyzer`, `ts_ls`, and `graphql`.

## Git

Gitsigns displays changed lines in the sign column.

| Key | Action |
| --- | --- |
| `[h` / `]h` | Go to the previous or next changed hunk |
| `<leader>hs` | Stage the current hunk |
| `<leader>hr` | Reset the current hunk |
| `<leader>hp` | Preview the current hunk |
| `<leader>hb` | Show blame information for the current line |

vim-fugitive and vim-rhubarb are also installed without custom key mappings.

## Editing Support

- **blink.cmp**: Provides completions from LSP, paths, snippets, and buffer
  contents. Use `<C-Space>` to show completions or documentation, `<C-y>` to
  accept, and `<C-e>` to cancel.
- **nvim-surround**: Use `ys{motion}{char}` to add a surrounding pair,
  `ds{char}` to delete one, and `cs{target}{replacement}` to change one.
  Examples: `ysiw"`, `ds"`, and `cs"'`.
- **Treesitter**: Provides syntax highlighting and indentation for supported
  languages.
- **which-key**: Displays available mappings after pressing `<leader>`.
- **lualine**: Displays the statusline and buffer/tab lists.
- **gruvbox.nvim**: Provides the dark color scheme.

Full-width spaces are highlighted.
