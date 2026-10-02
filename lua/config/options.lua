-- Opções do editor.
local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = "yes" -- coluna fixa: gitsigns/diagnósticos não fazem o texto "pular"
o.cursorline = true
o.scrolloff = 8
o.wrap = false
o.termguicolors = true
o.showmode = false -- o modo já aparece na statusline

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.inccommand = "split" -- prévia do :s/

o.splitright = true
o.splitbelow = true
o.clipboard = "unnamedplus" -- usa o clipboard do sistema (wl-clipboard no Wayland)
o.undofile = true
o.swapfile = false -- o Claude Code edita os mesmos arquivos; swap só gera avisos
o.updatetime = 250
o.timeoutlen = 400
o.mouse = "a"
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Recarregar arquivos alterados por fora (ver config/autocmds.lua).
o.autoread = true
