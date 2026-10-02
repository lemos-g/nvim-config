-- which-key: ao apertar <leader> (espaço) mostra os atalhos disponíveis.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>t", group = "testes/tema" },
      { "<leader>x", group = "diagnósticos" },
      { "<leader>c", group = "código/LSP" },
    },
  },
}
