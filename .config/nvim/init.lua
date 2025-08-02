vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.fn.setenv("PATH", vim.fn.getenv("HOME") .. "/.config/nvim/bin" .. ":" .. vim.fn.getenv("PATH"))

require("config.options")
require("core.lazy")
require("config.keymaps")
require("config.autocmds")

require("core.lsp")
