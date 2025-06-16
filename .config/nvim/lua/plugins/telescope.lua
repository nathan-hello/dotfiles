local builtin = require("telescope.builtin") -- See `:help telescope.builtin`

local M = {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        keys = {
                { "<leader>sh",       builtin.help_tags,   { desc = "[S]earch [H]elp" } },
                { "<leader>sk",       builtin.keymaps,     { desc = "[S]earch [K]eymaps" } },
                { "<leader>sf",       builtin.find_files,  { desc = "[S]earch [F]iles" } },
                { "<leader>ss",       builtin.builtin,     { desc = "[S]earch [S]elect Telescope" } },
                { "<leader>sw",       builtin.grep_string, { desc = "[S]earch current [W]ord" } },
                { "<leader>sg",       builtin.live_grep,   { desc = "[S]earch by [G]rep" } },
                { "<leader>sd",       builtin.diagnostics, { desc = "[S]earch [D]iagnostics" } },
                { "<leader>sr",       builtin.resume,      { desc = "[S]earch [R]esume" } },
                { "<leader>s.",       builtin.oldfiles,    { desc = '[S]earch Recent Files ("." for repeat)' } },
                { "<leader><leader>", builtin.buffers,     { desc = "[ ] Find existing buffers" } },

                -- Slightly advanced example of overriding default behavior and theme.
                -- Also possible to pass additional configuration options.
                -- See `:help telescope.builtin.live_grep()` for information about particular keys
                {
                        "<leader>/",
                        function()
                                -- You can pass additional configuration to telescope to change theme, layout, etc.
                                builtin.current_buffer_fuzzy_find(
                                        require("telescope.themes").get_dropdown({ winblend = 10, previewer = false })
                                )
                        end,
                        { desc = "[/] Fuzzily search in current buffer" }
                },

                {
                        "<leader>s/",
                        function()
                                builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
                        end,
                        { desc = "[S]earch [/] in Open Files" }
                },

                -- Shortcut for searching your neovim configuration files
                {
                        "<leader>sn",
                        function()
                                builtin.find_files({ cwd = vim.fn.stdpath("config") })
                        end,
                        { desc = "[S]earch [N]eovim files" }
                },
        },
        opts = {
                pickers = {
                        find_files = {
                                find_command = {
                                        "rg",
                                        "--files",
                                        "--hidden",           -- make :Telescope find_files find hidden files
                                        "--no-ignore",        -- make :Telescope find_files not respect gitignore
                                        "--glob",
                                        "!**/.git/*",         -- But it still won't look inside of these folders
                                        "--glob",
                                        "!**/node_modules/*", -- But it still won't look inside of these folders
                                },
                        },
                },
        },
        dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-tree/nvim-web-devicons" },
                { "nvim-telescope/telescope-ui-select.nvim" },
                {
                        "nvim-telescope/telescope-fzf-native.nvim",
                        build = "make",   -- `build` is used to run some command when the plugin is installed/updated. This is only run then, not every time Neovim starts up.
                        cond = function() -- `cond` is a condition used to determine whether this plugin should be installed and loaded.
                                return vim.fn.executable("make") == 1
                        end,
                },
        },
        config = function()
                -- Use Normal mode: ? to opens a window that shows you all of the keymaps for the current telescope picker. This is really useful to discover what Telescope can do as well as how to actually do it!
                require("telescope").setup({ -- See `:help telescope` and `:help telescope.setup()`
                        -- You can put your default mappings / updates / etc. in here. All the info you're looking for is in `:help telescope.setup()`
                        -- defaults = { mappings = { i = { ['<c-enter>'] = 'to_fuzzy_refine' }, }, },
                        -- pickers = {}
                        extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
                })

                -- Enable telescope extensions, if they are installed
                pcall(require("telescope").load_extension, "fzf")
                pcall(require("telescope").load_extension, "ui-select")
        end,
}


return M
