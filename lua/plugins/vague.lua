-- vague: só variante escura. Não tem opções de integração: traz grupos
-- próprios para snacks (picker, input) e mini, e os demais plugins herdam
-- dos grupos base — gitsigns via Added/Changed/Removed, noice/which-key via
-- NormalFloat/FloatBorder, diffview via Diff*, lualine pelo theme "auto".
return {
  "vague-theme/vague.nvim",
  lazy = true,
  opts = {
    transparent = false,
  },
}
