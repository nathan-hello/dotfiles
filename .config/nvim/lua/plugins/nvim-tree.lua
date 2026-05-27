local M = {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    view = { side = "right" },
    filters = {
      custom = { "node_modules" },
    },
    git = {
      enable = false,
    },
  },
}

return M
