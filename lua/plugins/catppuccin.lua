-- catppuccin: latte, frappe, macchiato e mocha.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = true,
  opts = {
    transparent_background = false,
    -- auto_integrations (padrão) liga o que o lazy.nvim tiver instalado;
    -- os plugins atuais ficam explícitos mesmo assim.
    integrations = {
      snacks = { enabled = true },
      noice = true,
      which_key = true,
      mini = { enabled = true },
    },
  },
}
