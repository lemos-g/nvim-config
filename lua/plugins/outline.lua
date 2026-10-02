-- aerial.nvim: painel com a estrutura do arquivo (funções, classes, tipos).
return {
  "stevearc/aerial.nvim",
  cmd = { "AerialToggle", "AerialOpen" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  keys = { { "<leader>cs", "<cmd>AerialToggle! right<CR>", desc = "Estrutura do arquivo" } },
  opts = {
    backends = { "lsp", "treesitter", "markdown" },
    layout = { min_width = 30 },
  },
}
