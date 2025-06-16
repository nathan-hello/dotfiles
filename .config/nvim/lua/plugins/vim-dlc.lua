local M = {
        "echasnovski/mini.nvim",
        config = function()
                -- Better Around/Inside textobjects
                -- Examples:
                --  va)  - [V]isually select [A]round [)]paren
                --  yinq - [Y]ank [I]nside [N]ext [']quote
                --  ci'  - [C]hange [I]nside [']quote
                require("mini.ai").setup({ n_lines = 500 })

                -- seems cool but disabled because it changes default behavior of 's' by itself - me 05apr2024
                -- Add/delete/replace surroundings (brackets, quotes, etc.)
                --  saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
                --  sd'   - [S]urround [D]elete [']quotes
                --  sr)'  - [S]urround [R]eplace [)] [']
                -- require("mini.surround").setup()
        end,
}

return M
