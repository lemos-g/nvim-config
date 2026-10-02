-- conform.nvim: formatar com o Prettier DO PROJETO (node_modules/.bin/prettier).
-- Nunca ao salvar — só pelo atalho <leader>cf. Fora de um projeto com
-- config do Prettier, não faz nada.
local prettier_fts = {
  "javascript", "javascriptreact", "typescript", "typescriptreact",
  "json", "jsonc", "css", "html", "markdown", "yaml",
}

return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true, lsp_format = "never" }) end,
      mode = { "n", "x" },
      desc = "Formatar (Prettier)",
    },
  },
  config = function()
    local util = require("conform.util")
    local by_ft = {}
    for _, ft in ipairs(prettier_fts) do by_ft[ft] = { "prettier" } end

    require("conform").setup({
      formatters_by_ft = by_ft,
      formatters = {
        prettier = {
          require_cwd = true,
          cwd = util.root_file({
            ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
            ".prettierrc.yaml", ".prettierrc.yml", "prettier.config.js", "prettier.config.cjs",
            "prettier.config.mjs", "prettier.config.ts",
          }),
        },
      },
    })
  end,
}
