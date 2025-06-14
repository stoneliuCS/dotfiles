-- Markdown plugins go here.
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "text" }, -- Load only for markdown and text files
    cmd = { "TableModeEnable", "TableModeToggle" },
    keys = {
      { "<Leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
    },
  },
}
