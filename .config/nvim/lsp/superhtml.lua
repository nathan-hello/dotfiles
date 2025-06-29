-- https://github.com/kristoff-it/superhtml

---@type vim.lsp.start.Opts
local M = {
        name = "superhtml",
        cmd = { "superhtml", "lsp" },
        filetypes = { "templ", "html" },
}

return M
