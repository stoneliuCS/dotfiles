return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Add swift lsp support
        sourcekit = {},
      },
    },
  },
}
