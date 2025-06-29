local M = {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
                -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
                -- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
                -- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
                -- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
                ---@diagnostic disable-next-line: missing-fields
                require("nvim-treesitter.configs").setup({
                        ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
                        auto_install = true,
                        highlight = { enable = true },
                        indent = { enable = true },
                })

        end,
}

return M
