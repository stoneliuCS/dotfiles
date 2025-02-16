return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "yaml-language-server",
        "texlab", -- LaTeX language server
        "latexindent", -- LaTeX formatter
        "nil", -- Nix language server
        "nixpkgs-fmt", -- Nix formatter
      },
    },
  },
}
