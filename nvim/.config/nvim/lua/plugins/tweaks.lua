-- Small QOL tweaks to LazyVim go here

-- Disabled Plugins go here, right now the current disabled plugins are
-- Bufferlines (Tabs)
-- Noice (The commandbar)
-- lualine for the bottom status bar
return {
  -- Disable the top buffer line
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  -- Disable the dashbord
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "ibhagwan/fzf-lua",
    opts = function(_)
      local fzf_lua = require("fzf-lua")
      vim.keymap.set("n", "<leader><space>", function()
        fzf_lua.files({ cwd = vim.fn.getcwd() })
      end, { desc = "Find Files in CWD" })

      vim.keymap.set("n", "<leader>sg", function()
        fzf_lua.live_grep({ cwd = vim.fn.getcwd() })
      end, { desc = "Live Grep in CWD" })
    end,
  },
  {
    "danymat/neogen",
    config = true,
    version = "*",
  },
  {
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end,
    },
  },
}
