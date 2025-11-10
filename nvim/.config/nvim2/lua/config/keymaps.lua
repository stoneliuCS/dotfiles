-- Global Keymaps
local map = vim.keymap.set
-- Normal Mode Keymaps
-- Buffer Mode Keymaps
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current buffer" })
-- Code Keymaps
map("n", "cd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show code diagnostics" })

-- Visual Mode Keymaps
-- Stay in visual mode after re-indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- Terminal Mode Keymaps
map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
