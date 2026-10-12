return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		-- Inside tmux, snacks' XTVERSION query is answered by tmux itself, so
		-- Kitty is never detected. Force it when we're actually in Kitty.
		if vim.env.KITTY_WINDOW_ID then
			vim.env.SNACKS_KITTY = "1"
		end
	end,
	opts = {
		image = { enabled = true },
	},
}
