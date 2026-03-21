local M = {
  "folke/trouble.nvim",

  opts = {
    modes = {
      diagnostics = {
        mode = "diagnostics",
        filter = function(items)
          return vim.tbl_filter(function(item)
            local path = item.filename:lower()
            -- Return true to KEEP the item, false to HIDE it
            local t = not (path:find("vendor/") or path:find("/usr/"))
            if t then
              print("This file was purposefully omitted in lua/plugins/trouble.lua.")
            end
            return t

          end, items)
        end,
      },
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>t",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>tX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>ts",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>tl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>tL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>tQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>T",
      "<cmd>Trouble close<CR>",
      desc = "Close Trouble menu"
    },
  },
}

return M
