return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    -- main one
    { "ms-jpq/coq_nvim",       branch = "coq" },

    -- 9000+ Snippets
    { "ms-jpq/coq.artifacts",  branch = "artifacts" },

    -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
    -- Need to **configure separately**
    { 'ms-jpq/coq.thirdparty', branch = "3p" }
    -- - shell repl
    -- - nvim lua api
    -- - scientific calculator
    -- - comment banner
    -- - etc
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = 'shut-up',
    }
  end,
  config = function()
    -- Your LSP settings here
  end,
}
