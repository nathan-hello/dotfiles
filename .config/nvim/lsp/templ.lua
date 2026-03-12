-- https://github.com/a-h/templ

local M = {
  cmd = { "templ", "lsp" },
  filetypes = { "templ" },
}

-- For some unknown reason, highlight = true doesn't work for templ files. 
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.templ',
  callback = function()
    vim.treesitter.start()
  end,
})

return M
