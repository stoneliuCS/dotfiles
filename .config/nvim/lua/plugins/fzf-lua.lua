return {
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
}
