-- neotest + neotest-vitest: rodar testes do Vitest de dentro do editor.
-- Monorepo: cada arquivo usa o vitest.config.* mais próximo (o do seu app)
-- e o vitest do node_modules desse app.

-- Pasta do app: onde está o vitest.config.* mais próximo do arquivo.
local function app_root(path)
  local found = vim.fs.find(function(name)
    return name:match("^vitest%.config%.[mc]?[jt]s$") or name:match("^vite%.config%.[mc]?[jt]s$")
  end, { path = vim.fs.dirname(path), upward = true })[1]
  return found and vim.fs.dirname(found) or vim.fn.getcwd()
end

local function current_app() return app_root(vim.api.nvim_buf_get_name(0)) end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  keys = {
    { "<leader>tn", function() require("neotest").run.run() end, desc = "Teste sob o cursor" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%:p")) end, desc = "Testes do arquivo" },
    { "<leader>ta", function() require("neotest").run.run(current_app()) end, desc = "Suíte do app" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Repetir último teste" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Painel de resumo" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Saída do teste" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Painel de saída" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%:p")) end, desc = "Watch do arquivo" },
    { "<leader>tx", function() require("neotest").run.stop() end, desc = "Parar testes" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          cwd = app_root,
          vitestCommand = function(path)
            local bin = app_root(path) .. "/node_modules/.bin/vitest"
            return vim.fn.executable(bin) == 1 and bin or "pnpm exec vitest"
          end,
          filter_dir = function(name) return name ~= "node_modules" end,
        }),
      },
    })
  end,
}
