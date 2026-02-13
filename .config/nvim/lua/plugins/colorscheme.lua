local Gruvbox = {
  "ellisonleao/gruvbox.nvim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd.colorscheme("gruvbox")
  end,

}

local Catppuccin = {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}

local uid = vim.system({ "id", "-u" }):wait().stdout:gsub("%s+", "")
if uid == "0" then
  return Catppuccin
else
  return Gruvbox
end
