return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  }),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "basic", -- "off", "basic", or "strict"
      },
    },
  },
  single_file_support = true,
}
