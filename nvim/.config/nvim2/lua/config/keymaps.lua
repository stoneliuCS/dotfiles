-- Global Keymaps
local map = vim.keymap.set

-- Buffer Mode Keymaps
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete current buffer" })

-- Split Window Keymaps
map("n", "<Tab>", "<C-w>w", { desc = "Next window" })

-- Code Keymaps
map("n", "cd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Show code diagnostics" })

-- Visual Mode Keymaps
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })

-- Terminal Mode Keymaps
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
