return {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
                '.luarc.json',
                '.luarc.jsonc',
                '.luacheckrc',
                '.stylua.toml',
                'stylua.toml',
                'selene.toml',
                'selene.yml',
                '.git',
        },
        settings = {
                Lua = {
                        diagnostics = {
                                disable = { "missing-fields" },
                                globals = { "vim" },
                        },
                        workspace = {
                                -- Make language server aware of runtime files
                                library = vim.api.nvim_get_runtime_file("", true),
                        },
                        hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                        },
                },
        },
}
