local M = {
        "iamcco/markdown-preview.nvim", -- https://github.com/iamcco/markdown-preview.nvim
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
                vim.fn["mkdp#util#install"]()
        end,
}

return M
