-- sudo xbps-install -S texlive-full

local M = {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- Viewer (Okular example; change if you use another)
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "okular"
    vim.g.vimtex_view_general_options = "--noraise --unique @pdf\\#src:@line@tex"

    -- Use latexmk with lualatex
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",            -- produce pdf
        "-pdflatex=lualatex", -- tell latexmk to use lualatex
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }
  end,
}
return M
