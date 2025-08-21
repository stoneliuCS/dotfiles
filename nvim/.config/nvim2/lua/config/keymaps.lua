local map = vim.keymap.set

map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<leader>g", "<cmd>FzfLua live_grep_native<cr>", { desc = "Live grep (cwd)" })
