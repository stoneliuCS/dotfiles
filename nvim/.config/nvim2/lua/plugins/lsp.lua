return {
  {
    "williamboman/mason.nvim",
    opts = {}, -- Optional: Add configuration options for Mason here
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "vtsls",
        "html",
        "cssls",
        "gopls",
        "texlab",
      },
      automatic_installation = true,
    },
  },
}
