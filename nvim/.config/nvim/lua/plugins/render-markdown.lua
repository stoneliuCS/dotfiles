return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		completions = { lsp = { enabled = true } },
		anti_conceal = { disabled_modes = { "n", "v" } },
		win_options = {
			concealcursor = { rendered = "nv" },
		},
	},
}
