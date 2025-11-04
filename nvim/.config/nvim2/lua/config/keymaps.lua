-- Global Keymaps
local map = vim.keymap.set
-- Buffer keymaps
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current buffer" })
-- Code Actions
map("n", "cd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show code diagnostics" })
-- Stay in visual mode after re-indenting
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
