return {
  -- Add the tokyonight plugin
  { "folke/tokyonight.nvim" },

  -- Configure LazyVim to load tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
