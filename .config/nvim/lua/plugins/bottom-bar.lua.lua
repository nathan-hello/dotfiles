local M = {
        "nvim-lualine/lualine.nvim",
        dependencies = {
                "nvim-tree/nvim-web-devicons",
        },
        opts = {
                options = { icons_enabled = false },
                sections = {
                        lualine_a = { "mode" },
                        lualine_b = { "branch", "diff", "diagnostics" },
                        lualine_c = { { "filename", path = 3 }, "filesize", "encoding" },
                        lualine_x = { "searchcount" },
                        lualine_y = {
                                function() -- Get a list of all LSPs active, and return them in a comma-separated string.
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
                                end,
                        },
                        lualine_z = { "hostname", "location" },
                },
        },
}

return M
