-- Tema ativo: seletor com preview ao vivo (<leader>uC) e persistência da
-- última escolha em stdpath("state")/theme, fora do repositório.
local M = {}

M.default = "kanagawa-wave"

-- Únicas opções do seletor, na ordem em que aparecem.
M.themes = {
  "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus",
  "catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe", "catppuccin-latte",
  "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day",
  "everforest-dark", "everforest-light",
}

-- Variantes claras; as demais são escuras.
local light = {
  ["kanagawa-lotus"] = true,
  ["catppuccin-latte"] = true,
  ["tokyonight-day"] = true,
  ["everforest-light"] = true,
}

local state_file = vim.fn.stdpath("state") .. "/theme"

local function read_saved()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  return ok and lines[1] or nil
end

local function apply(name)
  return pcall(vim.cmd.colorscheme, name)
end

-- Chamado no init.lua logo após o lazy.nvim, antes do dashboard e da UI.
function M.setup()
  -- Nem todo tema ajusta 'background' (o kanagawa não ajusta). Acertar antes
  -- de carregar vale também para o preview do seletor e :colorscheme manual.
  local group = vim.api.nvim_create_augroup("config.theme", { clear = true })
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = group,
    callback = function(ev)
      if vim.tbl_contains(M.themes, ev.match) then
        vim.o.background = light[ev.match] and "light" or "dark"
      end
    end,
  })
  -- Nome da variante ativa (vim.g.colors_name é só "kanagawa"/"everforest").
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function(ev) M.current = ev.match end,
  })

  local saved = read_saved()
  if saved and vim.tbl_contains(M.themes, saved) and apply(saved) then
    return
  end
  apply(M.default)
end

function M.pick()
  -- O preview mostra o tema aplicado ao arquivo atual (ou a este módulo).
  local file = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(file) == 0 then
    file = debug.getinfo(1, "S").source:sub(2)
  end

  local before = M.current
  Snacks.picker.colorschemes({
    title = "Temas",
    -- Ao cancelar, o snacks restaura vim.g.colors_name; aqui restaura a
    -- variante exata (ex.: kanagawa-dragon, não "kanagawa").
    preview = function(ctx)
      local ret = Snacks.picker.preview.colorscheme(ctx)
      ctx.preview.state.colorscheme = before
      return ret
    end,
    finder = function()
      return vim.tbl_map(function(name) return { text = name, file = file } end, M.themes)
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then return end
      picker.preview.state.colorscheme = nil -- não restaurar o tema anterior
      vim.schedule(function()
        if apply(item.text) then
          vim.fn.writefile({ item.text }, state_file)
        end
      end)
    end,
  })
end

return M
