local M = { -- You can easily change to a different colorscheme.
        -- Change the name of the colorscheme plugin below, and then change the command in the config to whatever the name of that colorscheme is
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
        --"catppuccin/nvim",
        --lazy = false,
        --priority = 1000,
        --config = function()
        --  vim.cmd.colorscheme("catppuccin-mocha")
        --end,
        "ellisonleao/gruvbox.nvim",
        lazy = false,                -- make sure we load this during startup if it is your main colorscheme
        priority = 1000,             -- make sure to load this before all the other start plugins
        config = function()
                vim.cmd.colorscheme("gruvbox") -- Load the colorscheme here
        end,

}

return M
