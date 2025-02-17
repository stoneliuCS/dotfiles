-- Ensures that vim tex and tree sitter doesn't collide with one another
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown" },
      highlight = {
        enable = true,
        disable = { "latex" },
        additional_vim_regex_highlighting = false,
      },
    },
  },
}
