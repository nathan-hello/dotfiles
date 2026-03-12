-- npm install -g @tailwindcss/language-server

local M = {
  cmd = { "tailwindcss-language-server" },
  filetypes = { "templ", "astro", "javascript", "typescript", "react", "typescriptreact" },
  init_options = {
    includeLanguages = { templ = "html" }
  },
  root_markers = { "app.css", "tailwind.config.js", "package.json" }
}

return M
