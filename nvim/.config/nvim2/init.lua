-- Load Lazy Configuration File
require("config.lazy")

-- Load the theme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- Load the configuration file
vim.lsp.config("luals", require("config.lsp.luals"))
vim.lsp.config("texlab", require("config.lsp.texlab"))

-- Enable LSPs
vim.lsp.enable({
	"luals",
	"texlab",
})
