-- Statusline global (laststatus=3), enxuta para leitura e revisão.

-- Caminho do arquivo relativo à raiz do repositório git; fora de um repo,
-- relativo ao diretório atual.
local function project_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return "[sem nome]"
  end
  local root = Snacks.git.get_root(path)
  if root and path:sub(1, #root + 1) == root .. "/" then
    return path:sub(#root + 2)
  end
  return vim.fn.fnamemodify(path, ":~:.")
end

-- Componentes de status do noice (ex.: comando pendente, "recording @q").
local function noice_status(name)
  return {
    function() return require("noice").api.status[name].get() end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status[name].has()
    end,
  }
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-mini/mini.icons" },
  init = function()
    -- Statusline vazia até o lualine carregar, para não piscar a padrão.
    vim.o.statusline = " "
  end,
  opts = {
    options = {
      theme = "kanagawa",
      globalstatus = true,
      disabled_filetypes = { statusline = { "snacks_dashboard" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        "diagnostics",
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        project_path,
      },
      lualine_x = {
        noice_status("command"),
        noice_status("mode"),
        "diff",
      },
      lualine_y = { "progress", "location" },
      lualine_z = {},
    },
    extensions = { "lazy" },
  },
}
