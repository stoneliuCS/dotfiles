return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local langs =
			{ "typescript", "tsx", "python", "javascript", "html", "css", "markdown", "markdown_inline", "lua", "go" }
		require("nvim-treesitter").install(langs)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
