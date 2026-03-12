--- git clone https://github.com/ThePrimeagen/htmx-lsp
--- cargo build --release
--- sudo cp ./target/release/htmx-lsp /usr/local/bin/htmx-lsp
---
---@type vim.lsp.Config
return {
  cmd = { "htmx-lsp" },
  filetypes = { "html", "react", "typescriptreact", "templ" },
  root_markers = { "package.json", '.git' },
}
