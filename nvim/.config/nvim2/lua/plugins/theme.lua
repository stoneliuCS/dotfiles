return {
	-- Gruvbox
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	-- Rose-pine
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
