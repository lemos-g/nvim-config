-- gitsigns: mudanças do arquivo enquanto se lê (sinais, preview, blame).
-- Só leitura: sem stage/reset — agir é no lazygit (<leader>gg).
--
-- Sinais: a statuscolumn do snacks reconhece os extmarks GitSigns* e os
-- desenha no espaço "git" dela (à direita dos números); não há coluna extra.
-- O lualine lê vim.b.gitsigns_status_dict para o componente de diff.
local function nav(direction)
  if vim.wo.diff then
    vim.cmd.normal({ direction == "next" and "]c" or "[c", bang = true })
  else
    require("gitsigns").nav_hunk(direction)
  end
end

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- ]h/[h são globais para valer também nos dois lados do diffview, onde o
  -- gitsigns não se anexa ao lado "antes": em modo diff viram ]c/[c.
  -- stylua: ignore
  keys = {
    { "]h", function() nav("next") end, desc = "Próximo trecho alterado" },
    { "[h", function() nav("prev") end, desc = "Trecho alterado anterior" },
  },
  opts = {
    current_line_blame = false, -- inline desligado; <leader>ub alterna
    current_line_blame_opts = { delay = 300 },
    preview_config = { border = "rounded" },
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
      end
      map("<leader>gh", gs.preview_hunk, "Preview do trecho alterado")
      map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame da linha")
    end,
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)
    Snacks.toggle({
      name = "Blame inline",
      get = function() return require("gitsigns.config").config.current_line_blame end,
      set = function(state) require("gitsigns").toggle_current_line_blame(state) end,
    }):map("<leader>ub")
  end,
}
