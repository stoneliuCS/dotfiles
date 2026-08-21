vim.filetype.add({
	extension = {
		trigger = "apex",
	},
})

-- vimtex's own ftdetect/cls.vim does a blunt `autocmd BufRead,BufNewFile
-- *.cls set filetype=tex`, which stomps whatever vim.filetype.add resolves
-- for *.cls regardless of extension/pattern precedence - so a plain
-- `extension = { cls = "apex" }` entry gets silently overridden. Correct it
-- back once vimtex has set "tex", but only for .cls files under a real
-- Salesforce project (an sfdx-project.json ancestor); genuine LaTeX .cls
-- files never have one.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function(args)
		local bufnr = args.buf
		if not vim.api.nvim_buf_get_name(bufnr):match("%.cls$") then
			return
		end
		if not vim.fs.root(bufnr, "sfdx-project.json") then
			return
		end
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
			if client.name == "texlab" then
				vim.lsp.buf_detach_client(bufnr, client.id)
			end
		end
		vim.bo[bufnr].filetype = "apex"
	end,
})
