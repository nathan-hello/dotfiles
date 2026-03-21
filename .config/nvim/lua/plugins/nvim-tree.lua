local M = {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    view = { side = "right" },
    git = {
      enable = false,
    }
  },
}

return M
