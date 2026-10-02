-- .apex (anonymous Apex execute-scripts)/.trigger/.agent/.soql aren't in Neovim's
-- builtin filetype detection at all, so apex_ls/agentscript_ls/soql_ls would never
-- attach without these.
vim.filetype.add({
	extension = {
		apex = "apex",
		trigger = "apex",
		agent = "agentscript",
		soql = "soql",
	},
})

-- .cls is ambiguous (LaTeX class vs Apex class) and vimtex's own
-- ftdetect/cls.vim unconditionally does `set filetype=tex` on BufRead/
-- BufNewFile, which fires after and overrides any vim.filetype.add extension
-- mapping here. Reclassify as apex only inside an sfdx project, after
-- vimtex has already set filetype=tex, by reacting to that FileType event.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		if name:match("%.cls$") and vim.fs.root(args.buf, "sfdx-project.json") then
			vim.bo[args.buf].filetype = "apex"
			-- vimtex's tex ftplugin already ran and left a buffer-local K
			-- mapping (opens package docs) behind; that blocks Neovim's
			-- default LSP hover-on-K keymap, which only sets itself when K
			-- is unmapped (see vim.lsp._set_defaults).
			pcall(vim.keymap.del, "n", "K", { buffer = args.buf })
		end
	end,
})
