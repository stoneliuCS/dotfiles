return {
    {
      "williamboman/mason.nvim",
      opts = {}, -- Optional: Add configuration options for Mason here
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
      opts = {}, -- Optional: Add configuration options for Mason-LSPconfig here
    },
}
