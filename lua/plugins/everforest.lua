-- everforest (neanias/everforest-nvim): escolhido sobre o sainnhe/everforest
-- por ter grupos para snacks, noice, which-key e mini.icons e tema do lualine
-- (o do sainnhe não cobre o noice). Não tem opções de integração: vem tudo.
-- Claro/escuro dependem de vim.o.background; colors/everforest-{dark,light}.lua
-- transformam isso em dois colorschemes selecionáveis.
return {
  "neanias/everforest-nvim",
  main = "everforest",
  lazy = true,
  opts = {
    background = "medium",
    transparent_background_level = 0,
  },
}
