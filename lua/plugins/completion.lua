-- blink.cmp: autocompletar (LSP, caminhos, palavras do buffer, snippets).
-- <C-y> aceita, <C-n>/<C-p> navegam, <C-space> abre/documentação.
return {
  "saghen/blink.cmp",
  version = "1.*", -- versões com binário pré-compilado do matcher
  event = "InsertEnter",
  opts = {
    keymap = { preset = "default" },
    completion = { documentation = { auto_show = true } },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    signature = { enabled = true },
  },
}
