return {
	"elihunter173/dirbuf.nvim",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dirbuf",
			callback = function()
				vim.keymap.set("n", "<BS>", "-", { buffer = true, remap = true })
				vim.keymap.set("n", "<Del>", "-", { buffer = true, remap = true })
			end,
		})
	end,
}
