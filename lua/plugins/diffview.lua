-- diffview: revisão em diff lado a lado (antes à esquerda, depois à direita).
-- Só leitura: os atalhos de ação do diffview (stage, restore, resolver
-- conflito, diffget) ficam desligados — agir é no lazygit (<leader>gg).
-- diffopt (histogram + linematch) e o hachurado ficam em config/options.lua.

-- Base do diff da branch: main, ou master em repositórios antigos.
local function base_branch()
  for _, name in ipairs({ "main", "master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", name })
    if vim.v.shell_error == 0 then
      return name
    end
  end
  vim.notify("Sem branch main ou master neste repositório", vim.log.levels.WARN)
end

-- Diff do PR: branch atual contra o merge-base com a main (main...HEAD),
-- opcionalmente restrito a pathspecs.
local function review_branch(paths)
  local base = base_branch()
  if not base then return end
  local args = { base .. "...HEAD" }
  if paths then
    vim.list_extend(args, { "--" })
    vim.list_extend(args, paths)
  end
  vim.cmd("DiffviewOpen " .. table.concat(args, " "))
end

-- Em todas as telas: q fecha o diffview e <C-e> mostra/esconde o painel.
local common = {
  { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Fechar o diffview" } },
  { "n", "<C-e>", function() require("diffview.actions").toggle_files() end, { desc = "Mostrar/esconder painel de arquivos" } },
}

-- Desligados em todas as telas: os locais que sombreiam <leader>e (explorer)
-- e o grupo <leader>b (buffer).
local shadowing = {
  { "n", "<leader>e", false },
  { "n", "<leader>b", false },
}

-- Ações de resolver conflito (escrevem no arquivo).
local conflict = {
  { "n", "<leader>co", false }, { "n", "<leader>ct", false },
  { "n", "<leader>cb", false }, { "n", "<leader>ca", false },
  { "n", "<leader>cO", false }, { "n", "<leader>cT", false },
  { "n", "<leader>cB", false }, { "n", "<leader>cA", false },
  { "n", "dx", false }, { "n", "dX", false },
}

-- Junta listas de keymaps do diffview.
local function keys(...)
  local ret = {}
  for _, list in ipairs({ ... }) do
    vim.list_extend(ret, list)
  end
  return ret
end

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  -- stylua: ignore
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview: não commitado" },
    { "<leader>gr", function() review_branch() end, desc = "Diffview: branch vs main (PR)" },
    { "<leader>gt", function() review_branch({ "*.test.ts", "*.test.tsx" }) end, desc = "Diffview: testes da branch" },
    { "<leader>gF", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: histórico do arquivo" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: histórico do repo" },
  },
  opts = {
    enhanced_diff_hl = true,
    use_icons = true, -- via mock de nvim-web-devicons do mini.icons
    view = {
      default = { layout = "diff2_horizontal" },
      file_history = { layout = "diff2_horizontal" },
    },
    file_panel = {
      listing_style = "tree",
    },
    -- O padrão (16 linhas) toma espaço demais do diff. O file_panel fica à
    -- esquerda e não é afetado.
    file_history_panel = {
      win_config = { position = "bottom", height = 10 },
    },
    keymaps = {
      view = keys(common, shadowing, conflict),
      diff3 = { { { "n", "x" }, "2do", false }, { { "n", "x" }, "3do", false } },
      diff4 = { { { "n", "x" }, "1do", false }, { { "n", "x" }, "2do", false }, { { "n", "x" }, "3do", false } },
      file_panel = keys(common, shadowing, conflict, {
        { "n", "-", false }, { "n", "s", false }, { "n", "S", false },
        { "n", "U", false }, { "n", "X", false },
      }),
      file_history_panel = keys(common, shadowing, { { "n", "X", false } }),
    },
  },
}
