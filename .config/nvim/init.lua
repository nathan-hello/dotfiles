vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("core.lazy")
require("config.keymaps")
require("config.autocmds")

require("core.lsp")
