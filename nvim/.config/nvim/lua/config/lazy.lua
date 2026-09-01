-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.undofile = true
vim.opt.number = true
vim.opt.colorcolumn = "120"
vim.opt.conceallevel = 0
vim.opt.swapfile = false
vim.opt.pumheight = 10
vim.opt.relativenumber = true
-- reserve the sign column permanently; the default "auto" collapses it
-- when no diagnostic/gitsign is present, shifting the whole buffer
-- sideways every time an error appears or clears
vim.opt.signcolumn = "yes"
-- Diagnostic Configuration
vim.diagnostic.config({
	-- half-typed code is always "wrong"; recomputing in insert mode makes
	-- errors flicker in and out on every keystroke. defer to InsertLeave.
	update_in_insert = true,
	virtual_text = {
		severity = { min = vim.diagnostic.severity.ERROR },
	},
	signs = true,
	underline = true,
	severity_sort = true,
})

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false },
})
require("config.keymaps")
require("config.autocmds")
