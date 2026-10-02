-- Git para revisar o que o agente fez:
--   diffview.nvim  diff da branch contra a main, histórico de arquivo, merge de conflitos
--   gitsigns.nvim  marcas das linhas alteradas, navegar/stage/reset de hunks, blame

-- Branch principal do repositório (main ou master).
local function main_branch()
  for _, name in ipairs({ "main", "master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", name })
    if vim.v.shell_error == 0 then return name end
  end
  return "main"
end

return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff: mudanças não commitadas" },
      { "<leader>gm", function() vim.cmd("DiffviewOpen " .. main_branch() .. "...HEAD") end, desc = "Diff: branch vs main" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Histórico do arquivo" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Histórico da branch" },
      { "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "Fechar diffview" },
    },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Próxima mudança (hunk)")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Mudança anterior (hunk)")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame da linha")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Blame inline (liga/desliga)")
        map("n", "<leader>gp", gs.preview_hunk, "Prévia do hunk")
        map({ "n", "x" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage/unstage do hunk")
        map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset do hunk")
        map("n", "<leader>gS", gs.stage_buffer, "Stage do arquivo")
        map("n", "<leader>gR", gs.reset_buffer, "Reset do arquivo")
      end,
    },
  },
}
