-- Load Lazy Configuration File
require("config.lazy")

-- Load the theme
vim.o.background = "dark"
vim.cmd([[colorscheme rose-pine-main]])

-- Load the lsps
vim.lsp.config("luals", require("config.lsp.luals"))
vim.lsp.config("texlab", require("config.lsp.texlab"))
vim.lsp.config("basedpyright", require("config.lsp.basedpyright"))

-- Enable LSPs
vim.lsp.enable({
	"luals",
	"texlab",
	"basedpyright",
})

-- Diagnostic Configuration
vim.diagnostic.config({
	update_in_insert = true,
	virtual_text = true,
	signs = true,
	underline = true,
	severity_sort = true,
})
