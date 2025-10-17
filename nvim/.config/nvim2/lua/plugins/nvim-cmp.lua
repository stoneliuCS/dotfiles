return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",

    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",

    -- LaTeX bits
    "lervag/vimtex",              -- LaTeX backbone
    "micangl/cmp-vimtex",         -- VimTeX-aware cmp source
    "kdheepak/cmp-latex-symbols", -- (optional) quick math symbols
  },
  event = "InsertEnter",
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = {
        { name = "vimtex" },           -- labels, refs, cites, file paths from VimTeX
        { name = "latex_symbols" },    -- quick \alpha, \beta, … (optional)
        { name = "nvim_lsp" },
        { name = "luasnip" },          -- actual snippet content
        { name = "buffer" },
        { name = "path" },
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
    })
  end,
}
