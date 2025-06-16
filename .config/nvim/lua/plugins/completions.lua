local M = {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
                -- Snippet Engine & its associated nvim-cmp source
                {
                        "L3MON4D3/LuaSnip",
                        build = (function()
                                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                                        return
                                end -- Build Step is needed for regex support in snippets This step is not supported in many windows environments Remove the below condition to re-enable on windows
                                return "make install_jsregexp"
                        end)(),
                },
                "saadparwaiz1/cmp_luasnip",

                -- Adds other completion capabilities. nvim-cmp does not ship with all sources by default. They are split into multiple repos for maintenance purposes.
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-path",

                "rafamadriz/friendly-snippets", -- If you want to add a bunch of pre-configured snippets, you can use this plugin to help you. It even has snippets for various frameworks/libraries/etc. but you will have to set up the ones that are useful for you.
        },
        config = function()
                -- See `:help cmp`
                local cmp = require("cmp")
                local luasnip = require("luasnip")
                luasnip.config.setup({})

                cmp.setup({
                        snippet = {
                                expand = function(args)
                                        luasnip.lsp_expand(args.body)
                                end,
                        },
                        completion = { completeopt = "menu,menuone,noinsert" },

                        -- For an understanding of why these mappings were chosen, you will need to read `:help ins-completion`. No, but seriously. Please read `:help ins-completion`, it is really good!
                        mapping = cmp.mapping.preset.insert({
                                ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                                ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                                ["<C-Space>"] = cmp.mapping.complete({}),
                                ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                                -- Think of <c-l> as moving to the right of your snippet expansion.
                                --  So if you have a snippet that's like:
                                --  function $name($args)
                                --    $body
                                --  end
                                -- <c-l> will move you to the right of each of the expansion locations.
                                -- <c-h> is similar, except moving you backwards.
                                ["<C-L>"] = cmp.mapping(function()
                                        if luasnip.expand_or_locally_jumpable() then
                                                luasnip.expand_or_jump()
                                        end
                                end, { "i", "s" }),
                                ["<C-H>"] = cmp.mapping(function()
                                        if luasnip.locally_jumpable(-1) then
                                                luasnip.jump(-1)
                                        end
                                end, { "i", "s" }),
                        }),
                        sources = {
                                { name = "nvim_lsp" },
                                { name = "luasnip" },
                                { name = "path" },
                        },
                })
        end,
}

return M
