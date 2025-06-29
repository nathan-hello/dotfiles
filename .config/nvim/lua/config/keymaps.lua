-- `:help vim.keymap.set()`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Clear search on pressing <Esc> in normal mode
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })

vim.keymap.set("n", "<C-1>", "<cmd>1wincmd w<CR>", { desc = "Move focus to window 1" })
vim.keymap.set("n", "<C-2>", "<cmd>2wincmd w<CR>", { desc = "Move focus to window 2" })
vim.keymap.set("n", "<C-3>", "<cmd>3wincmd w<CR>", { desc = "Move focus to window 3" })
vim.keymap.set("n", "<C-4>", "<cmd>4wincmd w<CR>", { desc = "Move focus to window 4" })
vim.keymap.set("n", "<leader>0", "<Cmd>NvimTreeFocus<CR>", { desc = "Focus NvimTree" })
vim.keymap.set("n", "<leader>)", "<Cmd>NvimTreeClose<CR>", { desc = "Close NvimTree" })
vim.keymap.set("n", "<leader>-", "<cmd>vertical resize -16<CR>", { desc = "Shrink window" })
vim.keymap.set("n", "<leader>=", "<cmd>vertical resize +16<CR>", { desc = "Grow window" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "When Jing, keep cursor at start" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor in middle when going up" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor in middle when going down" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep cursor in middle when searching" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor in middle when searching" })
vim.keymap.set("n", "<leader>h", "<cmd>noh<CR>", { desc = "Unhighlight find selections" })
vim.keymap.set({ "n", "v", "x" }, "<leader>p", [["_dP]], { desc = "System clipboard paste" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { desc = "System clipboard yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", [["_d]], { desc = "Delete text into empty buffer" })
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next entry in quickfix list" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous entry in quickfix list" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next entry in location list" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous entry in location list" })
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        { desc = "Find and replace word on hover" })






