-- Tema ativo e variantes disponíveis.
local M = {}

M.default = "kanagawa-wave"

-- Variantes dos temas instalados.
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

  apply(M.default)
end

return M
