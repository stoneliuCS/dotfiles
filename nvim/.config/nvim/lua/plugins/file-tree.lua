-- ~/.config/nvim2/lua/plugins/nvim-tree.lua
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	opts = {
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		},
	},

	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		require("nvim-tree").setup()
	end,
	keys = {
		{ "<leader>e", ":NvimTreeFindFileToggle<CR>", desc = "Toggle file tree" },
		{ "<leader>E", "<cmd>NvimTreeFocus<cr>", desc = "Focus file tree" },
	},
}
