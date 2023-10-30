vim.g.mapleader = " "
package.path = package.path .. ';/home/nate/.config/nvim/?.lua'

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
end vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-telescope/telescope.nvim",    dependencies = { "nvim-lua/plenary.nvim" } },    -- https://github.com/nvim-telescope/telescope.nvim
    { "catppuccin/nvim", name = "catppuccin-mocha", priority = 1000 },                     -- https://github.com/catppuccin/nvim
    { "tvim-treesitter/nvim-treesitter",  cmd = "TSUpdate" },                              -- https://github.com/nvim-treesitter/nvim-treesitter
    { "kdheepak/lazygit.nvim", dependencies = { "nvim-lua/plenary.nvim" }, },              -- https://github.com/kdheepak/lazygit.nvim
    { "kyazdani42/nvim-tree.lua", },                                                       -- https://github.com/nvim-tree/nvim-tree.lua
    { "kassio/neoterm"},                                                                   -- https://github.com/kassio/neoterm
    { "nvim-tree/nvim-web-devicons", },                                                    -- https://github.com/nvim-tree/nvim-web-devicons
    { 'williamboman/mason.nvim' },                                                         -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'williamboman/mason-lspconfig.nvim' },                                               -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },                                      -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'neovim/nvim-lspconfig' },                                                           -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'hrsh7th/cmp-nvim-lsp' },                                                            -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'hrsh7th/nvim-cmp' },                                                                -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'L3MON4D3/LuaSnip' },                                                                -- https://github.com/VonHeikemen/lsp-zero.nvim
    { 'voldikss/vim-floaterm' },
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim",dependencies = {
          "nvim-telescope/telescope.nvim",
          "nvim-lua/plenary.nvim"}
    },
    { "christoomey/vim-tmux-navigator" },
    { "folke/which-key.nvim",
        init = function() vim.o.timeout = true vim.o.timeoutlen = 999999 end,opts = {}
    },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

})

vim.cmd.colorscheme "catppuccin-mocha"
require('lualine').setup()

--    i have accepted defeat
--    { 'goolord/alpha-nvim', config = function ()
--	    require'telescope'.load_extension('project')
--	    require'alpha'.setup(require'dashboard'.config)
--    end,
--    event = "VimEnter", dependencies = { "nvim-lua/plenary.nvim" }
--    } ,
--    vim.cmd [[ autocmd VimEnter * Alpha ]]
--
-- floaterm configuration
vim.g.floaterm_keymap_toggle = '<F7>'
vim.g.floaterm_keymap_next = '<F8>'
vim.g.floaterm_keymap_prev = '<F9>'
vim.g.floaterm_keymap_new = '<F10>'
vim.g.floaterm_title = ''
vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.8
vim.g.floaterm_opacity = 0.9
vim.g.floaterm_autohide = 1

-- Function to open specific terminals
local function open_specific_terminal(index)
    vim.cmd(string.format("FloatermNew --name=term%d --autoclose=0", index))
end

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>ft', ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fn', ':FloatermNew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f1', '<cmd>lua open_specific_terminal(1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f2', '<cmd>lua open_specific_terminal(2)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f3', '<cmd>lua open_specific_terminal(3)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fc', ':FloatermKill<CR>', { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n><cmd>FloatermHide<CR>')

-- lazygit setup
vim.api.nvim_set_keymap('n', '<leader>lg', ':FloatermNew lazygit<CR>', { noremap = true, silent = true }) 
require("nvim-tree").setup({
    view = { side = "right" }
})

require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },                            -- Install these.
    ignore_install = { "javascript" },                                                      -- Don't install these.
    sync_install = false,                                                                   -- Install parsers synchronously (only applied to `ensure_installed`)
    auto_install = true,                                                                    -- Automatically install missing parsers when entering buffer

    highlight = {
        enable = true,                                                                      -- Highlighting is basically all of treesitter. 
        additional_vim_regex_highlighting = false,                                          -- Not using regex because it's cringe (it's slow i guess? idk)
    }
}

local telescope = require('telescope.builtin')

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)                -- Jump to definition
    vim.keymap.set("n", "H", function() vim.lsp.buf.hover() end, opts)                      -- Hovering over text reveals information about the symbol
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts) -- Search for a symbol, make a quicklist of all instances of that symbol
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)     -- Open all diagnostic info about current file
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)              -- Goto next problem
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)              -- Goto previous problem
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)      -- Open all available code actions
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)       -- Open all references to hovered symbol
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)           -- Rename all instances. Uses LSP.
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)         -- Open help in insert mode
end)

require('mason').setup({})
require('mason-lspconfig').setup({                                                          -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers    
    ensure_installed = {
        "tsserver",
        "lua_ls",
        "gopls",
        "pyright"
    },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            -- this assumes that this nvim file is the only one on the system.
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
    },
    formatting = lsp_zero.cmp_format(),
    mapping = cmp.mapping.preset.insert({
        ['<C-p>']     = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>']     = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>']     = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})


vim.g.loaded_netrw = 1                                                                      -- Disable netrw for NvimTree
vim.g.loaded_netrwPlugin = 1                                                                -- Disable netrw for NvimTree
vim.cmd [[
au InsertEnter * set norelativenumber
au InsertLeave * set relativenumber
]]                                                                                          -- Aboslute line in insert, relative in else


vim.opt.termguicolors = true                                                                -- Set termguicolors to enable highlight groups
vim.opt.guifont = "Hasklug Nerd Font Complete"                                              -- Set font
vim.opt.guicursor = ""                                                                      -- Empty string disables special GUI-based cursor styling.
vim.opt.nu = true                                                                           -- Enables line numbering.
vim.opt.tabstop = 4                                                                         -- Sets the number of spaces for a tab character.
vim.opt.softtabstop = 4                                                                     -- Number of spaces to use for auto-indenting.
vim.opt.shiftwidth = 4                                                                      -- Number of spaces to use for each step of auto-indent.
vim.opt.expandtab = true                                                                    -- Convert tabs to spaces.
vim.opt.smartindent = true                                                                  -- Enables smart indenting.
vim.opt.wrap = false                                                                        -- Disables line wrapping.
vim.opt.swapfile = false                                                                    -- Disables swap file creation.
vim.opt.backup = false                                                                      -- Disables backup file creation.
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"                                      -- Sets undo directory.
vim.opt.undofile = true                                                                     -- Enables undo persistence.
vim.opt.hlsearch = true                                                                     -- Highlight all search results.
vim.opt.incsearch = true                                                                    -- Highlights search matches as you type.
vim.opt.termguicolors = true                                                                -- Enables color.
vim.opt.scrolloff = 8                                                                       -- Keeps 8 lines between cursor and window edge while scrolling.
vim.opt.signcolumn = "yes"                                                                  -- Always show the sign column.
vim.opt.updatetime = 50                                                                     -- Sets the time (in ms) that triggers CursorHold event.

vim.keymap.set('n', '<leader>ff', telescope.find_files, {})                                 -- Open telescope
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})                                  -- Grep entire working dir
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})                                    -- Open buffers
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})                                  -- Search :help

vim.keymap.set('n', '<leader>1', '<cmd>1wincmd w<CR>')                                      -- Open window 1 
vim.keymap.set('n', '<leader>2', '<cmd>2wincmd w<CR>')                                      -- Open window 2
vim.keymap.set('n', '<leader>3', '<cmd>3wincmd w<CR>')                                      -- Open window 3
vim.keymap.set('n', '<leader>4', '<cmd>4wincmd w<CR>')                                      -- Open window 4
vim.keymap.set('n', '<leader>0', [[<Cmd>NvimTreeFocus<CR>]])                                -- Focus NvimTree
vim.keymap.set('n', '<leader>)', [[<Cmd>NvimTreeClose<CR>]])                                -- Close NvimTree

vim.keymap.set("n", "Q", "<nop>")                                                           -- Disable Q.
vim.keymap.set("n", "H", "<nop>")                                                           -- Disable H. Used for LSP hover. If no LSP exists, then it's annoying.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")                                                -- Move selection up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")                                                -- Move selection down
vim.keymap.set("n", "J", "mzJ`z")                                                           -- When Jing, keep cursor at start
vim.keymap.set("n", "<C-d>", "<C-d>zz")                                                     -- Keep cursor in middle when going up
vim.keymap.set("n", "<C-u>", "<C-u>zz")                                                     -- Keep cursor in middle when going down
vim.keymap.set("n", "n", "nzzzv")                                                           -- Keep cursor in middle when searching
vim.keymap.set("n", "N", "Nzzzv")                                                           -- Keep cursor in middle when searching
vim.keymap.set("x", "<leader>p", [["_dP]])                                                  -- System clipboard paste
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])                                          -- System clipboard yank
vim.keymap.set("n", "<leader>Y", [["+Y]])                                                   -- System clipboard yank current line
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])                                          -- Delete text without adding deletion to unnamed buffer
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)                                        -- Format file
vim.keymap.set("i", "<C-c>", "<Esc>")                                                       -- Esc alternative. Useful for multi-line apparently
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")                                            -- Next entry in quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")                                            -- Previous entry in quickfix list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")                                        -- Next entry in location list
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")                                        -- Previous entry in location list
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])    -- Find and replace all instances of word that the cursor is currently hovering over
vim.keymap.set("n", "<leader><leader>", "<cmd>WhichKey<CR>")                                -- Next entry in location list
