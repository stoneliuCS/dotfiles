return {
	"christoomey/vim-tmux-navigator",
	-- The plugin defines :TmuxNavigate* as commands, so lazy.nvim can defer
	-- loading until one is invoked -- but the keys below are what trigger
	-- them, so both lists must stay in sync.
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
	},
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate pane left" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate pane down" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate pane up" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate pane right" },
	},
}
