vim.o.autoread = true

-- wide tables render as one long line; wrap breaks their column
-- alignment across screen rows, so scroll horizontally instead
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = false
  end,
})
-- python's indent script skips brackets inside comments/strings via a legacy
-- syntax check (runtime/autoload/python.vim searchpairpos + synstack). treesitter
-- highlighting sets syntax to "", so that check goes blind and an unbalanced "("
-- in a comment reads as a real open bracket: every line below it indents to that
-- bracket's column. Loading the regex syntax restores the check; the treesitter
-- highlighter still wins on screen, it draws in a higher-priority namespace.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.syntax = "python"
  end,
})
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = "*",
})

-- tmux clears on-screen Kitty images when a pane loses focus (see
-- tmux.conf pane-focus-out hook) to stop them ghosting into other
-- windows/panes. Re-render image/pdf buffers on refocus so they come back.
vim.api.nvim_create_autocmd("FocusGained", {
  callback = function()
    local ok, image = pcall(require, "snacks.image")
    if ok and image.supports_file(vim.api.nvim_buf_get_name(0)) then
      vim.cmd("edit")
    end
  end,
})
