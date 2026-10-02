return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local langs = {
			"typescript",
			"tsx",
			"python",
			"javascript",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"lua",
			"go",
			"yaml",
			"xml",
			"templ",
			"java",
			"apex",
			"soql",
			"agentscript",
		}

		-- agentscript isn't in nvim-treesitter's registry; this is the
		-- documented way to register a parser that lives in a subdirectory
		-- of a "monorepo" (see README "Adding custom languages"). The
		-- `User TSUpdate` event fires from inside install(), before it reads
		-- the parser table, so registering here still takes effect below.
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				require("nvim-treesitter.parsers").agentscript = {
					install_info = {
						url = "https://github.com/salesforce/agentscript",
						location = "packages/parser-tree-sitter",
						revision = "cf60d0ee83a1fc24acacd72aed21514d08ee7a1c",
						queries = "queries",
					},
				}
			end,
		})

		require("nvim-treesitter").install(langs)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
