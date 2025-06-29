-- Highlight when yanking (copying) text. Try it with `yap` in normal mode. See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
        callback = function()
                vim.highlight.on_yank()
        end,
})

-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd(
        { "BufRead", "BufNewFile" },
        -- { pattern = { "*.txt", "*.md", "*.tex" }, command = [[setlocal spell<cr> setlocal spelllang=en,de<cr>]] }
        {
                pattern = { "*.txt", "*.md", "*.tex" },
                callback = function()
                        vim.opt.spell = true
                        vim.opt.spelllang = "en,de"
                end,
        }
)

-- don't auto comment new line
-- NATALIE:
-- vim.api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
        pattern = "*",
        command = "set cursorline",
        group = cursorGrp,
})
vim.api.nvim_create_autocmd(
        { "InsertEnter", "WinLeave" },
        { pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- resize neovim split when terminal is resized
vim.api.nvim_command("autocmd VimResized * wincmd =")


local override_formatters = {
        astro = function()
                vim.cmd("silent !cd " ..
                        vim.fn.expand('%:p:h') ..
                        " && prettier --write " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))) -- Call prettier binary inside of the directory that I'm in right now (for repo-specific configuration)
        end,
        javascript = function()
                vim.cmd("silent !cd " ..
                        vim.fn.expand('%:p:h') ..
                        " && prettier --write " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))) -- Call prettier binary inside of the directory that I'm in right now (for repo-specific configuration)
        end,
        typescript = function()
                vim.cmd("silent !cd " ..
                        vim.fn.expand('%:p:h') ..
                        " && prettier --write " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0))) -- Call prettier binary inside of the directory that I'm in right now (for repo-specific configuration)
        end,
        rust = function()
                vim.cmd("silent !cargo fmt -- " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
        end,
        templ = function()
                vim.cmd("silent !templ fmt -- " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
        end,
}

vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
                vim.lsp.buf.format = override_formatters[vim.bo.filetype] or vim.lsp.buf.format


                local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")                         -- Jump to the definition of the word under your cursor. To jump back, press <C-T>.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")                                             -- This is not Goto Definition, this is Goto Declaration. For example, in C this would take you to the header
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")                          -- Find references for the word under your cursor.
                map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")                 -- Jump to the implementation of the word under your cursor. Useful when your language has ways of declaring types without an actual implementation.
                map("H", vim.lsp.buf.hover, "[H]over Documentation")                                                   -- Opens a popup that displays documentation about the word under your cursor See `:help K` for why this keymap
                map("<leader>lf", vim.lsp.buf.format, "[L]SP [F]ormat")                                                -- Format file
                map("<leader>ld", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")               -- Jump to the type of the word under your cursor. Useful when you're not sure what type a variable is and you want to see the definition of its *type*, not where it was *defined*.
                map("<leader>lrn", vim.lsp.buf.rename, "[R]e[n]ame")                                                    -- Rename the variable under your cursor. Most Language Servers support renaming across files, etc
                map("<leader>lca", vim.lsp.buf.code_action, "[C]ode [A]ction")                                          -- Execute a code action, usually your cursor needs to be on top of an error or a suggestion from your LSP for this to activate.
                map("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols") -- Fuzzy find all the symbols in your current workspace Similar to document symbols, except searches over your whole project.
                map("<leader>lds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")           -- Fuzzy find all the symbols in your current document. Symbols are things like variables, functions, types, etc.

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                                buffer = event.buf,
                                callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" },
                                { buffer = event.buf, callback = vim.lsp.buf.clear_references, })
                end
        end
})
