-- mini.nvim, só quatro módulos:
--   surround   sa/sd/sr: adicionar/apagar/trocar delimitadores (ex.: saiw")
--   comment    gc{movimento} / gcc: comentar
--   pairs      fecha (), [], {}, aspas automaticamente
--   statusline barra de status
return {
  "echasnovski/mini.nvim",
  version = false,
  lazy = false,
  config = function()
    require("mini.surround").setup()
    require("mini.comment").setup()
    require("mini.pairs").setup()
    require("mini.statusline").setup({ use_icons = true })
  end,
}
