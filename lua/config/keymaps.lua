-- Atalhos que não dependem de plugin. Os de plugin ficam junto de cada plugin.
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque da busca" })

-- Janelas
map("n", "<C-h>", "<C-w>h", { desc = "Janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela à direita" })

-- Quickfix (usado pelo :Typecheck e por buscas)
map("n", "]q", "<cmd>cnext<CR>", { desc = "Próximo item da quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Item anterior da quickfix" })

-- Diagnósticos
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnóstico da linha" })

-- Typecheck do projeto inteiro (tsc --noEmit)
map("n", "<leader>ct", function() require("config.typecheck").run() end, { desc = "Typecheck do projeto (tsc)" })
vim.api.nvim_create_user_command("Typecheck", function() require("config.typecheck").run() end, {})

-- Tema
map("n", "<leader>tt", function() require("config.theme").pick() end, { desc = "Escolher tema" })
