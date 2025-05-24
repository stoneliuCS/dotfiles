-- Disabled Plugins go here, right now the current disabled plugins are
-- Bufferlines (Tabs)
-- Noice (The commandbar)
-- lualine for the bottom status bar
return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "", -- Remove component separators
          section_separators = "", -- Remove section separators
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
}
