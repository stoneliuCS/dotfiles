return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_skim_sync = 0
    vim.g.vimtex_view_skim_activate = 1

    -- Enable continuous compilation
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1,
      build_dir = "build",
      callback = 1,
      executable = "latexmk",
      options = {
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Optional: disable some default mappings if they conflict
    vim.g.vimtex_mappings_enabled = 1

    vim.g.vimtex_complete_enabled = 1
    vim.g.vimtex_complete_close_braces = 1
  end,
}
