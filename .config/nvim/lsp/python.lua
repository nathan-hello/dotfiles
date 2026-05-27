---pythom -m venv .venv
---source .venv/bin/activate
---pip install pyrefly
---sudo mv .venv/bin/pyrefly /usr/local/bin/pyrefly
---@type vim.lsp.Config
return {
  cmd = { 'pyrefly', 'lsp' },
  filetypes = { 'python' },
  root_markers = { '.venv' },
}
