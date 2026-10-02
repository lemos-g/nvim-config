-- Leader precisa existir antes do lazy.nvim registrar os atalhos dos plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local o = vim.opt

-- Números e colunas
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true

-- Visual
o.termguicolors = true
o.winborder = "rounded"
o.laststatus = 3
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8

-- Janelas
o.splitright = true
o.splitbelow = true

-- Busca
o.ignorecase = true
o.smartcase = true

-- Persistência e responsividade
o.undofile = true
o.updatetime = 250

-- Clipboard do sistema (Wayland via wl-clipboard)
o.clipboard = "unnamedplus"
