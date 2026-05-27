local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter")
    configs.setup({
      auto_install = true,
      ensure_installed = {
        "c",
        "cpp",
        "css",
        "go",
        "html",
        "javascript",
        "json",
        "jsonc",
        "lua",
        "templ",
        "typescript",
        "tsx",
        "zig",
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

return M
