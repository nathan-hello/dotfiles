local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = {
    toggler = { line = "<leader>c", block = "<leader>bc" },
    opleader = { line = "<leader>c", block = "<leader>bc" },
    pre_hook = function(ctx)
      return require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()(ctx)
    end,
  },
}

return M
