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
    },
  },
}
