-- Autocomandos. O principal: recarregar sozinho os arquivos que o Claude Code
-- (ou qualquer outro processo) altera enquanto estão abertos aqui.
local group = vim.api.nvim_create_augroup("config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Destacar o texto copiado",
  callback = function() vim.hl.on_yank() end,
})

-- Recarga automática ----------------------------------------------------------

-- :checktime compara cada buffer com o disco. Não pode rodar com a linha de
-- comando aberta nem na janela de comandos (q:).
local function checktime()
  local mode = vim.api.nvim_get_mode().mode
  if mode:match("^c") or mode:match("^r") or vim.fn.getcmdwintype() ~= "" then return end
  vim.cmd("silent! checktime")
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = group,
  desc = "Verificar se o arquivo mudou no disco",
  callback = checktime,
})

-- Vigia periódico: o terminal nem sempre avisa o foco, e o arquivo pode mudar
-- enquanto você só está lendo. A cada 1,5 s confere os buffers abertos.
local timer = vim.uv.new_timer()
timer:start(1500, 1500, vim.schedule_wrap(checktime))
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function() timer:stop(); timer:close() end,
})

-- Decide o que fazer quando o arquivo mudou por fora:
-- sem alterações locais -> recarrega; com alterações não salvas -> só avisa.
vim.api.nvim_create_autocmd("FileChangedShell", {
  group = group,
  callback = function(args)
    local name = vim.fn.fnamemodify(args.file, ":~:.")
    if vim.v.fcs_reason == "deleted" then
      vim.v.fcs_choice = ""
      vim.notify(name .. " foi apagado no disco.", vim.log.levels.WARN)
    elseif vim.bo[args.buf].modified then
      vim.v.fcs_choice = ""
      vim.notify(
        name .. " mudou no disco, mas tem alterações não salvas aqui.\n"
          .. ":e! descarta as suas e recarrega · :w! sobrescreve o disco",
        vim.log.levels.WARN
      )
    else
      vim.v.fcs_choice = "reload"
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = group,
  callback = function(args)
    vim.notify("Recarregado: " .. vim.fn.fnamemodify(args.file, ":~:."), vim.log.levels.INFO)
  end,
})
