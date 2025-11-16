-- Load Lazy Configuration File
require("config.lazy")

-- Load the theme
vim.o.background = "dark"
vim.cmd([[colorscheme rose-pine-main]])

-- Load the lsps
vim.lsp.config("luals", require("config.lsp.luals"))
vim.lsp.config("texlab", require("config.lsp.texlab"))
vim.lsp.config("basedpyright", require("config.lsp.basedpyright"))
vim.lsp.config("pyright", require("config.lsp.pyright"))
vim.lsp.config("vtsls", require("config.lsp.vtsls"))
vim.lsp.config("dockerls", require("config.lsp.dockerls"))
vim.lsp.config("yamlls", require("config.lsp.yamlls"))

-- Enable LSPs
vim.lsp.enable({
	"luals",
	"texlab",
	"pyright",
	"vtsls",
	"dockerls",
	"yamlls",
})
