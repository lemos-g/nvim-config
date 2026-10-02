-- Linha de comando flutuante, busca embaixo e mensagens organizadas.
-- vim.notify continua com o notifier do snacks: o noice não o substitui, e
-- a view "notify" do noice já usa o snacks como backend (sem nvim-notify).

-- O cmdline popup (":") fica centralizado pelo nui (row/col "50%"). O noice
-- relê posição e tamanho do popupmenu a cada exibição, então eles são
-- recalculados ao abrir o cmdline: o menu cai logo abaixo do popup e nunca
-- passa da tela (senão o nui o empurra para cima, por cima do popup).
local function place_cmdline_popupmenu()
  local popup_row = math.floor((vim.o.lines - 3) * 0.5) -- 3 = texto + bordas
  local row = popup_row + 4 -- primeira linha de conteúdo, abaixo da borda
  local view = require("noice.config").options.views.cmdline_popupmenu
  view.position = { row = row, col = "50%" }
  -- espaço abaixo: borda inferior, statusline e linha de comando
  view.size.max_height = math.max(3, math.min(15, vim.o.lines - row - 3))
end

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
    views = {
      cmdline_popup = { position = { row = "50%", col = "50%" } },
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
  config = function(_, opts)
    require("noice").setup(opts)
    vim.api.nvim_create_autocmd("CmdlineEnter", { callback = place_cmdline_popupmenu })
  end,
}
