-- lua/plugins/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				-- Set the timeout to be 5 seconds for large files
				require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 5000 })
			end,
			desc = "Format file",
		},
	},
	opts = {
		notify_on_error = false,

		formatters_by_ft = {
			lua = { "stylua" },

			javascript = { "oxfmt", "prettierd", "prettier" },
			typescript = { "oxfmt", "prettierd", "prettier" },
			javascriptreact = { "oxfmt", "prettierd", "prettier" },
			typescriptreact = { "oxfmt", "prettierd", "prettier" },
			vue = { "prettierd", "prettier" },
			svelte = { "prettierd", "prettier" },
			json = { "prettierd", "jq" },
			jsonc = { "prettierd" },
			yaml = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			markdown = { "prettierd" },
			graphql = { "prettierd" },
			typst = { "typstyle" },

			sh = { "shfmt" },
			python = { "ruff_format", "black" },
			go = { "goimports", "gofmt" },
			rust = { "rustfmt" },
		},
	},
}
