local M = {
        cmd = { "clangd", "--clang-tidy" },
        filetypes = {"c", "h", "cpp", "hpp", "cc" },
        root_markers = { "Makefile" }
}

return M
