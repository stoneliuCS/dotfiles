-- Global Keymaps
local map = vim.keymap.set
-- Buffer keymaps
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Previous buffer" })
map("n", "cd", "<cmd>lua vim.diagnostic.open_float()<CR>" , { desc = "Show code diagnostics" })

