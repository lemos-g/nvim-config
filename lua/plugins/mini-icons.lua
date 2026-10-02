-- Provedor único de ícones. O snacks usa o mini.icons direto; para plugins
-- que esperam nvim-web-devicons (lualine), o módulo é emulado sob demanda —
-- o nvim-web-devicons não é instalado.
return {
  "nvim-mini/mini.icons",
  lazy = true,
  opts = {},
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
