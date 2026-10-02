-- Atalhos que não dependem de plugins. Os que chamam Snacks.* ficam em
-- lua/plugins/snacks.lua (campo `keys`), para carregarem junto com o plugin.

-- Alterna entre nome.ts e nome.test.ts (qualquer extensão), abrindo em vsplit.
local function toggle_test_file()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Buffer sem arquivo", vim.log.levels.WARN)
    return
  end

  local target
  if path:match("%.test%.(%w+)$") then
    target = path:gsub("%.test(%.%w+)$", "%1")
  else
    target = path:gsub("(%.%w+)$", ".test%1")
  end

  if target == path then
    vim.notify("Arquivo sem extensão", vim.log.levels.WARN)
  elseif vim.uv.fs_stat(target) then
    vim.cmd.vsplit(vim.fn.fnameescape(target))
  else
    vim.notify("Não existe: " .. vim.fn.fnamemodify(target, ":~:."), vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>ct", toggle_test_file, { desc = "Alternar teste ↔ fonte" })
