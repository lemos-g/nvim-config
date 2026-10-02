-- Bootstrap do lazy.nvim: na primeira abertura clona o gerenciador e instala tudo.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Falha ao clonar lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "kanagawa" } }, -- tema usado durante a instalação inicial
  checker = { enabled = false }, -- versões fixas no lazy-lock.json; atualizar com :Lazy update
  change_detection = { notify = false },
  rocks = { enabled = false }, -- nenhum plugin aqui precisa de luarocks
})
