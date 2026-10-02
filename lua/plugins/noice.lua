-- Linha de comando flutuante, busca embaixo e mensagens organizadas.
-- vim.notify continua com o notifier do snacks: o noice não o substitui, e
-- a view "notify" do noice já usa o snacks como backend (sem nvim-notify).
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    notify = { enabled = false },
    lsp = {
      -- Documentação/hover do LSP renderizada como markdown pelo noice.
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    routes = {
      -- Escrita de arquivo e undo/redo vão para a view discreta "mini".
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      -- Borda arredondada no hover do LSP (os demais flutuantes do noice
      -- já vêm com "rounded").
      lsp_doc_border = true,
    },
  },
}
