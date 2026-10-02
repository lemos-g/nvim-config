-- kanagawa: wave, dragon e lotus. Não tem opções de integração: os grupos de
-- snacks, noice, which-key e mini.icons e o tema do lualine vêm sempre.
-- O tema ativo é aplicado por lua/config/theme.lua.
return {
  "rebelot/kanagawa.nvim",
  lazy = true,
  opts = {
    background = { dark = "wave", light = "lotus" },
    transparent = false,
  },
}
