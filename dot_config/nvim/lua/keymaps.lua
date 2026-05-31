local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- File operations
map("n", "<leader>w", "<cmd>w<cr>",  { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<cr>",  { desc = "Quit" })

-- Insert mode escape
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc><Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Visual mode: cursor positioning after yank
map("v", "y", "y`]", { desc = "Yank and move to end" })

-- Visual mode: paste without overwriting unnamed register
map("x", "p", '"_dP', { desc = "Paste without yanking" })

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>",     { desc = "Next buffer" })

-- Terminal mode escape
map("t", "<C-n><C-n>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
