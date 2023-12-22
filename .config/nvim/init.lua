local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable" })
end
vim.opt.rtp:prepend(lazypath)
package.path = package.path .. ';' .. vim.fn.stdpath('config') .. '/?.lua'

require("lazy").setup({
    { "folke/which-key.nvim" },                                                                                          -- https://github.com/folke/which-key.nvim
    { "numToStr/Comment.nvim" },                                                                                         -- https://github.com/numToStr/Comment.nvim
    { "JoosepAlviste/nvim-ts-context-commentstring" },                                                                   -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    { "neovim/nvim-lspconfig" },                                                                                         -- https://github.com/VonHeikemen/lsp-zero.nvim
    { "williamboman/mason.nvim" },                                                                                       -- https://github.com/VonHeikemen/lsp-zero.nvim
    { "kyazdani42/nvim-tree.lua", },                                                                                     -- https://github.com/nvim-tree/nvim-tree.lua
    { "nvim-tree/nvim-web-devicons", },                                                                                  -- https://github.com/nvim-tree/nvim-web-devicons
    { "williamboman/mason-lspconfig.nvim" },                                                                             -- https://github.com/williamboman/mason-lspconfig.nvim
    { "VonHeikemen/lsp-zero.nvim",                  branch = "v3.x" },                                                   -- https://github.com/VonHeikemen/lsp-zero.nvim
    { "nvim-treesitter/nvim-treesitter",            cmd = "TSUpdate" },                                                  -- https://github.com/nvim-treesitter/nvim-treesitter
    { "catppuccin/nvim",                            name = "catppuccin-mocha",                        priority = 1000 }, -- https://github.com/catppuccin/nvim
    { "kdheepak/lazygit.nvim",                      dependencies = { "nvim-lua/plenary.nvim" }, },                       -- https://github.com/kdheepak/lazygit.nvim
    { "nvim-lualine/lualine.nvim",                  dependencies = { "nvim-tree/nvim-web-devicons" } },                  -- https://github.com/nvim-lualine/lualine.nvim
    { "nvim-telescope/telescope.nvim",              dependencies = { "nvim-lua/plenary.nvim" } },                        -- https://github.com/nvim-telescope/telescope.nvim
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lua" },
    { "saadparwaiz1/cmp_luasnip" },
    { "folke/neodev.nvim" },
    { "L3MON4D3/LuaSnip" },
    { "RRethy/vim-illuminate" },
    { "maxmellon/vim-jsx-pretty" },
    { "wuelnerdotexe/vim-astro" },
    { "folke/trouble.nvim",                         dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    }, -- https://github.com/iamcco/markdown-preview.nvim
    -- { "joerdav/templ.vim"},
    -- { "vrischmann/tree-sitter-templ", config = function() require("tree-sitter-templ").setup({}) end }                  -- https://github.com/vrischmann/tree-sitter-templ/commit/2a8326a0ee921c5ed24b3e627283390b7bf1d64f
})

vim.g.mapleader = " "                                     -- Space!
vim.cmd.colorscheme "catppuccin-mocha"                    -- https://github.com/catppuccin/nvim
vim.g.loaded_netrw = 1                                    -- Disable netrw for NvimTree
require("nvim-tree").setup({ view = { side = "right" } }) -- Nvim Tree
local telescope = require("telescope.builtin")            -- Telescope for keybinds later

local function lsp_status()
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
        return "No LSP"
    else
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
    end
end

require("lualine").setup({
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {},
        lualine_x = { 'encoding', 'filename', lsp_status },
        lualine_y = { 'location' },
        lualine_z = {}
    },
})

vim.opt.termguicolors = true                                                                    -- Set termguicolors to enable highlight groups
vim.opt.guicursor =
""                                                                                              -- Empty string disables special GUI-based cursor styling.
vim.opt.nu = true                                                                               -- Enables line numbering.
vim.opt.tabstop = 4                                                                             -- Sets the number of spaces for a tab character.
vim.opt.softtabstop = 4                                                                         -- Number of spaces to use for auto-indenting.
vim.opt.shiftwidth = 4                                                                          -- Number of spaces to use for each step of auto-indent.
vim.opt.expandtab = true                                                                        -- Convert tabs to spaces.
vim.opt.smartindent = true                                                                      -- Enables smart indenting.
vim.opt.wrap = false                                                                            -- Disables line wrapping.
vim.opt.swapfile = false                                                                        -- Disables swap file creation.
vim.opt.backup = false                                                                          -- Disables backup file creation.
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"                                          -- Sets undo directory.
vim.opt.undofile = true                                                                         -- Enables undo persistence.
vim.opt.hlsearch = true                                                                         -- Highlight all search results.
vim.opt.incsearch = true                                                                        -- Highlights search matches as you type.
vim.opt.termguicolors = true                                                                    -- Enables color.
vim.opt.scrolloff = 8                                                                           -- Keeps 8 lines between cursor and window edge while scrolling.
vim.opt.signcolumn =
"yes"                                                                                           -- Always show the sign column.
vim.opt.updatetime = 50                                                                         -- Sets the time (in ms) that triggers CursorHold event.
vim.api.nvim_create_autocmd("InsertEnter", { pattern = '*', command = 'set norelativenumber' }) -- Relative line numbers in insert mode
vim.api.nvim_create_autocmd("InsertLeave", { pattern = '*', command = 'set relativenumber' })   -- Disable relative line when leaving insert

vim.keymap.set("n", "Q", "<nop>")                                                               -- Disable Q.
vim.keymap.set("n", "H", "<nop>")                                                               -- Disable H. Used for LSP hover. If no LSP exists, then it"s annoying.

vim.keymap.set("n", "<leader>1", "<cmd>1wincmd w<CR>")                                          -- Open window 1
vim.keymap.set("n", "<leader>2", "<cmd>2wincmd w<CR>")                                          -- Open window 2
vim.keymap.set("n", "<leader>3", "<cmd>3wincmd w<CR>")                                          -- Open window 3
vim.keymap.set("n", "<leader>4", "<cmd>4wincmd w<CR>")                                          -- Open window 4
vim.keymap.set("n", "<leader>0", "<Cmd>NvimTreeFocus<CR>")                                      -- Focus NvimTree
vim.keymap.set("n", "<leader>)", "<Cmd>NvimTreeClose<CR>")                                      -- Close NvimTree
vim.keymap.set("n", "<leader>-", "<cmd>vertical resize -16<CR>")                                -- Shrink window
vim.keymap.set("n", "<leader>=", "<cmd>vertical resize +16<CR>")                                -- Grow window

vim.keymap.set("n", "<leader>ff", telescope.find_files)                                         -- Open telescope
vim.keymap.set("n", "<leader>fg", telescope.live_grep)                                          -- Grep entire working dir
vim.keymap.set("n", "<leader>fb", telescope.buffers)                                            -- Open buffers
vim.keymap.set("n", "<leader>fh", telescope.help_tags)                                          -- Search :help

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")                                                    -- Move selection up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")                                                    -- Move selection down
vim.keymap.set("n", "J", "mzJ`z")                                                               -- When Jing, keep cursor at start
vim.keymap.set("n", "<C-d>", "<C-d>zz")                                                         -- Keep cursor in middle when going up
vim.keymap.set("n", "<C-u>", "<C-u>zz")                                                         -- Keep cursor in middle when going down
vim.keymap.set("n", "n", "nzzzv")                                                               -- Keep cursor in middle when searching
vim.keymap.set("n", "N", "Nzzzv")                                                               -- Keep cursor in middle when searching
vim.keymap.set({ "n", "v", "x" }, "<leader>p", [["_dP]])                                        -- System clipboard paste
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]])                                         -- System clipboard yank
vim.keymap.set({ "n", "v", "x" }, "<leader>Y", [["+Y]])                                         -- System clipboard yank current line
vim.keymap.set({ "n", "v", "x" }, "<leader>d", [["_d]])                                         -- Delete text without adding deletion to unnamed buffer
vim.keymap.set("i", "<C-c>", "<Esc>")                                                           -- Esc alternative. Useful for multi-line apparently
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")                                                -- Next entry in quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")                                                -- Previous entry in quickfix list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")                                            -- Next entry in location list
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")                                            -- Previous entry in location list
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])        -- Find and replace all instances of word that the cursor is currently hovering over
vim.keymap.set("n", "<leader><leader>", "<cmd>WhichKey<CR>")                                    -- Next entry in location list

require("neodev").setup({})                                                                     -- LSP integration specifically for using lua to configure nvim
require("mason").setup()                                                                        -- LSP package manager
require('Comment').setup({                                                                      -- LSP specifically for adding comments
    toggler = { line = "<leader>c", block = "<leader>bc" },
    opleader = { line = "<leader>c", block = "<leader>bc" }
})
require('ts_context_commentstring').setup({})                                 -- LSP specifically for adding comments in JSX/TSX
require("nvim-treesitter.configs").setup({                                    -- Treesitter setup
    auto_install = true,                                                      -- Auto install missing parser when entering buffer
    highlight = { enabled = true, additional_vim_regex_highlighting = true }, -- Highlight!
})

require("luasnip")

local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
local cmp = require('cmp')
local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")
capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require("mason-lspconfig").setup({ handlers = { lsp_zero.default_setup } })

cmp.setup({
    sources = { { name = "nvim_lsp" }, { name = "luasnip" }, },
    window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered(), },
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-Space>'] = cmp.mapping.complete({}),
        ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true, },
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
})

local custom_format = function()
    if vim.bo.filetype == "astro" then
        local cmd = "silent !prettier --write " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
        vim.cmd(cmd)
    else
        vim.lsp.buf.format()
    end
end

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "H", vim.lsp.buf.hover, opts)                            -- Hovering over text reveals information about the symbol
    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)              -- Jump to definition
    vim.keymap.set('n', '<leader>ltd', vim.lsp.buf.type_definition, opts)        -- [not sure]
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)       -- [not sure]
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)           -- Open quickfix
    vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, opts)            -- Goto next problem
    vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, opts)            -- Goto previous problem
    vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, opts)       -- Search for a symbol, make a quicklist of all instances of that symbol
    vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)            -- Open all available code actions
    vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, opts)             -- Open all references to hovered symbol
    vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)                 -- Rename all instances. Uses LSP.
    vim.keymap.set("n", "<leader>lf", custom_format, opts)                       -- Format file
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)    -- Inform LSP of workspace folder
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts) -- Remove workspace folder from LSP
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))                 -- List workspace folders
    end, opts)
    require("illuminate").on_attach(client)
end

local on_attach_with_2_space_tabs = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    vim.api.nvim_buf_set_option(bufnr, 'expandtab', true)                        -- Tab = Space
    vim.api.nvim_buf_set_option(bufnr, 'tabstop', 2)                             -- 2 space tab
    vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 2)                          -- 2 space tab
    vim.keymap.set("n", "H", vim.lsp.buf.hover, opts)                            -- Hovering over text reveals information about the symbol
    vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)              -- Jump to definition
    vim.keymap.set('n', '<leader>ltd', vim.lsp.buf.type_definition, opts)        -- [not sure]
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)       -- [not sure]
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)           -- Open quickfix
    vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, opts)            -- Goto next problem
    vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, opts)            -- Goto previous problem
    vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, opts)       -- Search for a symbol, make a quicklist of all instances of that symbol
    vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)            -- Open all available code actions
    vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, opts)             -- Open all references to hovered symbol
    vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)                 -- Rename all instances. Uses LSP.
    vim.keymap.set("n", "<leader>lf", custom_format, opts)                       -- Format file
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)    -- Inform LSP of workspace folder
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts) -- Remove workspace folder from LSP
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))                 -- List workspace folders
    end, opts)
    require("illuminate").on_attach(client)
end

-- LSPs! --
lspconfig.html.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
    filetypes = {"html", "templ"},
})

lspconfig.templ.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
})

vim.filetype.add({ extension = { templ = "templ" } })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.templ",
    callback = function() vim.cmd("TSBufEnable highlight") end
})

lspconfig.htmx.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
    filetypes = {"html", "templ"},
})

lspconfig.tsserver.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
})

lspconfig.astro.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
})

vim.cmd [[
let g:astro_typescript = 'enable'
]]

lspconfig.tailwindcss.setup({
    on_attach = on_attach_with_2_space_tabs,
    capabilities = capabilities,
    filetypes = { "templ", "astro", "javascript", "typescript", "react" },
    init_options = { userLanguages = { templ = "html" } },
})

lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            semanticTokens = true,
            staticcheck = true,
            analyses = { unusedparams = true, },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    }
})

vim.api.nvim_create_autocmd("BufWritePre", { -- Go automatic import sorting
    pattern = "*.go",                        -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = { enable = false },
            workspace = { checkThirdParty = false } -- Disabled because libraries don't make the optional parts of config optional in the type system. }
        }
    }
})
