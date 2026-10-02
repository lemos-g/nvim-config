-- Tema único: kanagawa-wave, fundo sólido.
-- Carrega antes de tudo (priority > snacks) para os outros plugins já
-- encontrarem os highlights definidos.
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1100,
  opts = {
    theme = "wave",
    background = { dark = "wave", light = "wave" },
    transparent = false,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa-wave")
  end,
}
