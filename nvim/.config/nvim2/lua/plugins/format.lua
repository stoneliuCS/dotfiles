-- lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        -- Set the timeout to be 5 seconds for large files
        require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 5000 })
      end,
      desc = "Format file",
    },
  },
  opts = {
    notify_on_error = false,

    formatters_by_ft = {
      lua = { "stylua" },

      javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier" },
      svelte = { "prettierd", "prettier" },
      json = { "prettierd", "jq" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      markdown = { "prettierd" },
      graphql = { "prettierd" },
      typst = { "typstyle" },

      sh = { "shfmt" },
      python = { "ruff_format", "black" },
      go = { "goimports", "gofmt" },
      rust = { "rustfmt" },
    },
  },
}
