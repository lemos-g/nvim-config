-- Ponto de entrada. Leader precisa ser definido antes de carregar os plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy") -- instala/carrega os plugins de lua/plugins/
require("config.theme").load() -- aplica o tema salvo (ou Kanagawa)
