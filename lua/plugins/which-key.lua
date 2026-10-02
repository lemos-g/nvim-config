-- Popup com os atalhos disponíveis após um prefixo.
-- O preset "modern" já usa borda "rounded" e o which-key pega os ícones do
-- mini.icons. Os toggles do Snacks (<leader>u) se registram sozinhos aqui,
-- com ícone e texto refletindo o estado ligado/desligado.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- Os nomes dos grupos estão em português, então as regras automáticas
    -- de ícone (que procuram "find", "code", "ui"...) não casam; os ícones
    -- abaixo são os mesmos que essas regras usariam.
    spec = {
      { "<leader>f", group = "encontrar", icon = { icon = " ", color = "green" } },
      { "<leader>g", group = "git", icon = { cat = "filetype", name = "git" } },
      { "<leader>c", group = "código", icon = { icon = " ", color = "orange" } },
      { "<leader>u", group = "interface", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>b", group = "buffer", icon = { icon = "󰈔", color = "cyan" } },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Atalhos locais do buffer",
    },
  },
}
