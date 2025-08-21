return {
  "jay-babu/mason-nvim-dap.nvim",
  dependencies = { "https://github.com/williamboman/mason.nvim.git", "mfussenegger/nvim-dap" },
  opts = {
    ensure_installed = { "python" },  -- -> installs Mason package "debugpy"
    automatic_installation = true,
  },
}
