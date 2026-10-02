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
    -- Claro: o DiffText vem invertido (texto creme sobre azul, contraste
    -- 3.1). Texto normal sobre um azul claro sobe para 3.8 e continua
    -- distinto do DiffChange.
    on_highlights = function(hl, palette)
      if vim.o.background == "light" then
        hl.DiffText = { fg = palette.fg, bg = require("everforest.colour_utility").blend(palette.blue, 0.3, palette.bg0) }
      end
    end,
  },
}
