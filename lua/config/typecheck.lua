-- Roda `tsc --noEmit` do projeto do arquivo atual e joga os erros na quickfix
-- (aberta no Trouble). O LSP do TS só reporta arquivos abertos; isto pega todos.
local M = {}

-- Diretório do tsconfig.json mais próximo, subindo a partir do arquivo atual.
local function project_dir()
  local start = vim.api.nvim_buf_get_name(0)
  if start == "" then start = vim.fn.getcwd() end
  local found = vim.fs.find("tsconfig.json", { path = vim.fs.dirname(start), upward = true })[1]
  return found and vim.fs.dirname(found)
end

-- tsc do node_modules do projeto (sobe até achar, cobre o monorepo).
local function tsc_bin(dir)
  local bin = vim.fs.find("node_modules/.bin/tsc", { path = dir, upward = true })[1]
  return bin
end

function M.run()
  local dir = project_dir()
  if not dir then
    return vim.notify("Nenhum tsconfig.json encontrado acima deste arquivo.", vim.log.levels.WARN)
  end
  local tsc = tsc_bin(dir)
  if not tsc then
    return vim.notify("typescript não instalado em " .. dir .. " (node_modules/.bin/tsc)", vim.log.levels.WARN)
  end

  local label = vim.fn.fnamemodify(dir, ":~:.")
  vim.notify("tsc --noEmit em " .. label .. "…")
  vim.system({ tsc, "--noEmit", "--pretty", "false", "-p", dir }, { cwd = dir, text = true }, function(res)
    vim.schedule(function()
      local lines = {}
      for line in ((res.stdout or "") .. (res.stderr or "")):gmatch("[^\n]+") do
        -- tsc imprime caminhos relativos ao cwd dele; torna absolutos.
        if line:match("^[^%s].-%(%d+,%d+%)") and not line:match("^/") then
          line = dir .. "/" .. line
        end
        table.insert(lines, line)
      end
      vim.fn.setqflist({}, " ", {
        title = "tsc " .. label,
        lines = lines,
        efm = "%f(%l\\,%c): %trror TS%n: %m,%f(%l\\,%c): %tarning TS%n: %m,%-G%.%#",
      })
      local count = #vim.fn.getqflist()
      if count == 0 then
        if res.code == 0 then
          vim.notify("tsc: nenhum erro em " .. label)
        else
          vim.notify("tsc saiu com código " .. res.code .. ":\n" .. table.concat(lines, "\n"), vim.log.levels.ERROR)
        end
      else
        vim.notify(("tsc: %d erro(s) em %s"):format(count, label), vim.log.levels.WARN)
        vim.cmd("Trouble qflist open")
      end
    end)
  end)
end

return M
