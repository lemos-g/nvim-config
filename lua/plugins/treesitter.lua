-- nvim-treesitter: realce de sintaxe e indentação baseados em árvore sintática.
-- Usa o branch `main` (o atual); os parsers são compilados com o CLI tree-sitter.
local parsers = {
  "typescript", "tsx", "javascript", "json", "lua", "sql",
  "markdown", "markdown_inline", "css", "html", "bash",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
      callback = function(args)
        -- Só liga se houver parser para a linguagem deste buffer.
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
