-- Everforest escuro como colorscheme próprio (ver lua/plugins/everforest.lua).
-- Chama o load() direto: um :colorscheme aninhado é ignorado pelo nvim.
vim.o.background = "dark"
require("everforest").load()
