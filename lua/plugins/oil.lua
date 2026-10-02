-- oil.nvim: o diretório vira um buffer; renomear/criar/apagar = editar texto e :w.
-- `-` abre a pasta do arquivo atual (e sobe um nível dentro do oil).
return {
  "stevearc/oil.nvim",
  lazy = false, -- precisa estar pronto para `nvim .`
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = { { "-", "<cmd>Oil<CR>", desc = "Abrir pasta (oil)" } },
  opts = {
    default_file_explorer = true,
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
  },
}
