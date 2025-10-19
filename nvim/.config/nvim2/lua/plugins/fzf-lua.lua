return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	opts = {
		keymap = {
			fzf = {
				["tab"] = "down",
				["shift-tab"] = "up",
			},
		},
	},
	keys = {
		{
			"<leader><leader>",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},
		{
			"<leader>g",
			function()
				require("fzf-lua").live_grep_native()
			end,
			desc = "Live grep (cwd)",
		},
		{
			"<leader>b",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find current buffers",
		},
	},
}
