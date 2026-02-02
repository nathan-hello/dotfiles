local M = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter")
    configs.setup({
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

return M
