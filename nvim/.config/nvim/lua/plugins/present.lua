return {
	"tjdevries/present.nvim",
	ft = "markdown",
	config = function()
		require("present").setup({
			executors = {
				-- Run a ```vim block as Ex commands, capturing :echo output.
				vim = function(block)
					local ok, out = pcall(vim.api.nvim_exec2, block.body, { output = true })
					return vim.split(ok and (out.output or "") or tostring(out), "\n")
				end,
				bash = require("present").create_system_executor("bash"),
			},
		})

		vim.keymap.set("n", "<leader>sp", "<cmd>PresentStart<cr>", { desc = "[S]tart [P]resentation" })
	end,
}
