return {
  { "nvim-java/nvim-java" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Add swift lsp support
        sourcekit = {
          cmd = { "sourcekit-lsp" },
          filetypes = { "swift", "c", "cpp", "objective-c", "objective-cpp" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "buildServer.json",
              "Package.swift",
              ".git",
              "compile_commands.json",
              "compile_flags.txt"
            )(fname)
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function() end,
  },
}
