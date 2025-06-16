-- TODO: verify binary exists before starting nvim

---@type vim.lsp.start.Opts
local M = {
        name = "superhtml",
        cmd = { "superhtml", "lsp" },
        filetypes = { "templ", "html" },
}

return M
