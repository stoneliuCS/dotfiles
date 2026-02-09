-- Load Lazy Configuration File
require("config.lazy")

-- Load the theme
vim.cmd([[colorscheme rose-pine]])

local coq = require "coq"

-- Load the lsps
vim.lsp.config("luals", coq.lsp_ensure_capabilities(require("config.lsp.luals")))
vim.lsp.config("texlab", coq.lsp_ensure_capabilities(require("config.lsp.texlab")))
vim.lsp.config("basedpyright", coq.lsp_ensure_capabilities(require("config.lsp.basedpyright")))
vim.lsp.config("pyright", coq.lsp_ensure_capabilities(require("config.lsp.pyright")))
vim.lsp.config("vtsls", coq.lsp_ensure_capabilities(require("config.lsp.vtsls")))
vim.lsp.config("dockerls", coq.lsp_ensure_capabilities(require("config.lsp.dockerls")))
vim.lsp.config("yamlls", coq.lsp_ensure_capabilities(require("config.lsp.yamlls")))
vim.lsp.config("gopls", coq.lsp_ensure_capabilities(require("config.lsp.gopls")))
vim.lsp.config("rust-analyzer", coq.lsp_ensure_capabilities(require("config.lsp.rust-analyzer")))
vim.lsp.config("tinymist", coq.lsp_ensure_capabilities(require("config.lsp.tinymist")))
vim.lsp.config("templ", coq.lsp_ensure_capabilities(require("config.lsp.templ")))
vim.lsp.config("ts_go_ls", coq.lsp_ensure_capabilities(require("config.lsp.ts_go_ls")))
vim.lsp.config("tailwindcss", coq.lsp_ensure_capabilities(require("config.lsp.tailwindcss")))

-- Enable LSPs
vim.lsp.enable({
  "luals",
  "texlab",
  "pyright",
  "dockerls",
  "yamlls",
  "gopls",
  "rust-analyzer",
  "tinymist",
  "templ",
  "ts_go_ls",
  "tailwindcss",
})
