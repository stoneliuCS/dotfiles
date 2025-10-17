-- lua language server
local lua_ls_setup = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  -- Sets the "workspace" to the directory where any of these files is found.
  -- Files that share a root directory will reuse the LSP server connection.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
  -- Specific settings to send to the server. The schema is server-defined.
  -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    }
  }
}

-- Configuration settings for the nvim-lspconfig plugin
local nvim_lspconfig = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.lsp.config("lua_ls", lua_ls_setup)
    vim.lsp.config("basedpyright", {})
    vim.lsp.config("texlab", {})
  end,

  enable = function()
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("basedpyright")
    vim.lsp.enable("texlab")
  end,
}

return { nvim_lspconfig }
