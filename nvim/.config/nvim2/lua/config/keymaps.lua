-- Global Keymaps
local map = vim.keymap.set
-- Buffer keymaps
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Previous buffer" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
map("n", "<leader>cd", "<cmd>lua vim.diagnostic.open_float()<CR>" , { desc = "Show code diagnostics" })

