-- https://github.com/a-h/templ

local M = {
        cmd = { "templ", "lsp" },
        filetypes = { "templ" },
}

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*.templ",
-- 	callback = function()
-- 		vim.cmd("TSBufEnable highlight")
-- 	end,
-- })


return M
