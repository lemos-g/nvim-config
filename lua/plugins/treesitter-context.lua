-- Fixa no topo a função/describe/it em que o cursor está, para não perder o
-- contexto em arquivos longos (ex.: .test.ts). Usa o vim.treesitter nativo e
-- os parsers instalados por lua/plugins/treesitter.lua.
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    max_lines = 3,
    multiline_threshold = 1, -- cada contexto ocupa uma linha
    mode = "cursor",
  },
}
