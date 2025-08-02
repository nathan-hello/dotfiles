-- npm install -g @tailwindcss/language-server

local M = {
        cmd = { "tailwindcss-language-server" },
        filetypes = { "templ", "astro", "javascript", "typescript", "react" },
        init_options = {
                includeLanguages = { templ = "html" }
        },
}

return M
