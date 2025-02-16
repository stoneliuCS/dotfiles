return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        latex = { "latexindent" },
        tex = { "latexindent" },
        nix = { "nixpkgs-fmt" },
      },
    },
  },
}
