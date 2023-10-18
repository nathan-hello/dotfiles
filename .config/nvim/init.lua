local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.guifont = "Hasklug Nerd Font Complete"

require("lazy").setup({
	-- https://github.com/nvim-telescope/telescope.nvim
	{ "nvim-telescope/telescope.nvim", tag = '0.1.4', dependencies = { "nvim-lua/plenary.nvim" } },
	-- https://github.com/catppuccin/nvim
	{ "catppuccin/nvim", name = "catppuccin-mocha", priority = 1000 },
	-- https://github.com/nvim-treesitter/nvim-treesitter
	{ "nvim-treesitter/nvim-treesitter", cmd = "TSUpdate" },
	-- https://github.com/kdheepak/lazygit.nvim
	{ "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" }, },
	{ "kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle" },
})

require("nvim-tree").setup({})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
  sync_install = false,              -- Install parsers synchronously (only applied to `ensure_installed`)
  auto_install = true,               -- Automatically install missing parsers when entering buffer
  ignore_install = { "javascript" }, -- List of parsers to ignore installing (or "all")

  highlight = {
    enable = true,

    -- disable = { "c", "rust" },    -- list of language that will be disabled (name of parser, not file extension)
    additional_vim_regex_highlighting = false,
  },
}

vim.cmd.colorscheme "catppuccin-mocha"

vim.g.mapleader = " "

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
