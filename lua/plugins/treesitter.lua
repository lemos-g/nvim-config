-- nvim-treesitter, branch main (a reescrita para nvim 0.12; a master está
-- congelada). Só instala parsers e fornece queries/indentação; o highlight é
-- o vim.treesitter nativo, ligado por FileType abaixo.
-- Requer tree-sitter-cli (dnf), compilador C, curl e tar. Não suporta
-- lazy-loading.

-- Fonte única dos parsers. luadoc, markdown_inline e regex só aparecem por
-- injeção (dentro de lua, markdown e js/ts). Não há parser jsonc no main: o
-- nvim usa o de json (que aceita comentários) para o filetype jsonc.
local parsers = {
  "typescript", "tsx", "javascript", "json", "css", "html",
  "lua", "luadoc", "vim", "vimdoc", "query",
  "markdown", "markdown_inline", "yaml", "toml", "bash", "sql", "regex",
  "diff", "gitcommit", "git_rebase", "gitignore",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  -- Num clone novo, o `Lazy! sync` instala o plugin e roda isto: compila
  -- todos os parsers de forma síncrona. Nas atualizações, acompanha as
  -- revisões fixadas pelo nvim-treesitter (que o lazy-lock.json fixa).
  build = function()
    local ts = require("nvim-treesitter")
    ts.install(parsers):wait(300000)
    ts.update():wait(300000)
  end,
  config = function()
    -- Instala o que faltar (ex.: parser novo na lista); não faz nada se
    -- estiver tudo instalado.
    require("nvim-treesitter").install(parsers)

    local wanted = {}
    for _, lang in ipairs(parsers) do
      wanted[lang] = true
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("config.treesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not (lang and wanted[lang]) then return end
        -- pcall: o parser pode ainda estar compilando na primeira abertura.
        if pcall(vim.treesitter.start, ev.buf, lang) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
