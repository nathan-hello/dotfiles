-- See `:help vim.opt`. For more options, you can see `:help option-list`
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim. Remove this option if you want your OS clipboard to remain independent. See `:help 'clipboard'`
vim.opt.number = true        -- alternatively, vim.opt.relativenumber = true
vim.opt.mouse = "a"          -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false     -- Don't show the mode, since it's already in status line
vim.opt.breakindent = true   -- Enable break indent
vim.opt.undofile = true      -- Save undo history
vim.opt.ignorecase = true    -- Case-insensitive searching
vim.opt.smartcase = true     -- UNLESS \C or capital in search
vim.opt.signcolumn =
"yes"                        -- Keep signcolumn on by default (extra column beside line number for information e.g. git, diagnostic)
vim.opt.updatetime = 250     -- Decrease update time
vim.opt.timeoutlen = 300
vim.opt.splitright = true    -- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.list = false         -- Sets how neovim will display certain whitespace in the editor. See `:help 'list'` and `:help 'listchars'`
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true    -- Show which line your cursor is on
vim.opt.scrolloff = 10       -- Minimal number of screen lines to keep above and below the cursor.
vim.wo.wrap = false          -- Disable line wrap
vim.opt.hlsearch = true      -- Set highlight on search
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g["vimtex_view_method"] = "zathura"
vim.g["vimtex_view_general_viewer"] = "okular"
vim.g["vimtex_view_general_options"] = "-unique file:@pdf\\#src:@line@tex"
vim.g["vimtex_compiler_method"] = "latexmk"

