-- npm install -g typescript-language-server typescript

---@type vim.lsp.Config
local M = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "package.json", "tsconfig.json" },
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative"
    }
  }
}

return M
