-- Load Lazy Configuration File
require("config.lazy")
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undo'
