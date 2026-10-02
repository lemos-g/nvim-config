-- tokyonight: night, storm, moon e day.
return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    transparent = false,
    plugins = {
      -- auto (padrão) liga o que o lazy.nvim tiver instalado; os plugins
      -- atuais ficam explícitos mesmo assim.
      auto = true,
      snacks = true,
      noice = true,
      ["which-key"] = true,
      mini_icons = true,
      -- Sem grupo próprio para o diffview: ele usa os Diff* do tema.
      gitsigns = true,
    },
    -- day: o DiffText original (#92a6d5) deixa o texto com contraste 2.4;
    -- metade do caminho até o fundo sobe para 3.4 e segue distinto do
    -- DiffChange.
    on_highlights = function(hl, c)
      if vim.o.background == "light" then
        hl.DiffText = { bg = require("tokyonight.util").blend(c.diff.text, 0.5, c.bg) }
      end
    end,
  },
}
