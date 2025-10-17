-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>cf", function() require("conform").format({ async = false, lsp_fallback = true }) end, desc = "Format file" },
  },
  opts = {
    notify_on_error = false,

    -- Choose formatters per filetype (first available wins)
    formatters_by_ft = {
      lua             = { "stylua" },

      javascript      = { "prettierd", "prettier" },
      typescript      = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      vue             = { "prettierd", "prettier" },
      svelte          = { "prettierd", "prettier" },
      json            = { "prettierd", "jq" },
      jsonc           = { "prettierd" },
      yaml            = { "prettierd" },
      html            = { "prettierd" },
      css             = { "prettierd" },
      scss            = { "prettierd" },
      markdown        = { "prettierd" },
      graphql         = { "prettierd" },

      sh              = { "shfmt" },
      python          = { "ruff_format", "black" },
      go              = { "goimports", "gofmt" },
      rust            = { "rustfmt" },
    },
  },
}
