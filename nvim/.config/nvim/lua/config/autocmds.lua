vim.o.autoread = true
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
