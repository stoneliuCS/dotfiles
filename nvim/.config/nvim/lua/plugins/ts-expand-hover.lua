return {
	"nemanjamalesija/ts-expand-hover.nvim",
	lazy = true,
	opts = {
		keymaps = { hover = "<leader>th" },
	},
	init = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "vtsls" then
					require("lazy").load({ plugins = { "ts-expand-hover.nvim" } })
					return true
				end
			end,
		})
	end,
}
