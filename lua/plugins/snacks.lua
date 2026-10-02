-- snacks.nvim: picker, explorer, git, dashboard e utilidades de interface.
--
-- Bordas: a fonte única é vim.o.winborder ("rounded", em options.lua).
-- No snacks, `border = true` significa "usar winborder". notification,
-- notification_history, input, snacks_image e os layouts do picker já vêm
-- com `border = true`; só lazygit, terminal (float) e zen vêm sem borda.
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Ligados
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
        grep = { hidden = true },
        explorer = { hidden = true },
      },
    },
    explorer = { enabled = true, replace_netrw = true },
    words = { enabled = true },
    indent = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    lazygit = { enabled = true },
    gh = { enabled = true },
    scroll = { enabled = true },
    animate = { enabled = true },
    dim = { enabled = true },
    zen = { enabled = true },
    notifier = { enabled = true },
    input = { enabled = true },
    image = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    terminal = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = "nvim · revisão",
        -- stylua: ignore
        keys = {
          { icon = " ", key = "f", desc = "Arquivos",  action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "g", desc = "Grep",      action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Recentes",  action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "l", desc = "Lazygit",   action = ":lua Snacks.lazygit()" },
          { icon = " ", key = "e", desc = "Explorer",  action = ":lua Snacks.explorer()" },
          { icon = "󰒲 ", key = "L", desc = "Lazy",      action = ":Lazy" },
          { icon = " ", key = "q", desc = "Sair",      action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { icon = " ", title = "Recentes", section = "recent_files", cwd = true, indent = 2, padding = 1 },
        { icon = " ", title = "Projetos", section = "projects", indent = 2, padding = 1 },
      },
    },

    -- Desligados de propósito
    gitbrowse = { enabled = false },
    scratch = { enabled = false },
    rename = { enabled = false },
    debug = { enabled = false },
    profiler = { enabled = false },

    styles = {
      lazygit = { border = true },
      terminal = { border = true },
      zen = { border = true },
    },
  },

  -- stylua: ignore
  keys = {
    -- Encontrar
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Arquivos" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep da palavra/seleção", mode = { "n", "x" } },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recentes" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>f/", function() Snacks.picker.lines() end, desc = "Linhas do buffer" },
    { "<leader>fp", function() Snacks.picker.resume() end, desc = "Retomar último picker" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log do arquivo" },
    { "<leader>gL", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git diff (hunks)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs" },
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub issues" },

    -- Código (LSP; inertes até existir um servidor anexado)
    { "<leader>cr", function() Snacks.picker.lsp_references() end, desc = "Referências", nowait = true },
    { "<leader>cd", function() Snacks.picker.lsp_definitions() end, desc = "Definição" },
    { "<leader>cD", function() Snacks.picker.lsp_declarations() end, desc = "Declaração" },
    { "<leader>ci", function() Snacks.picker.lsp_implementations() end, desc = "Implementações" },
    { "<leader>cy", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definition" },
    { "<leader>cs", function() Snacks.picker.lsp_symbols() end, desc = "Símbolos do arquivo" },
    { "<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Símbolos do workspace" },
    { "<leader>cc", function() Snacks.picker.lsp_incoming_calls() end, desc = "Chamadas recebidas" },
    { "<leader>cC", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Chamadas feitas" },

    -- Interface
    { "<leader>uz", function() Snacks.zen() end, desc = "Zen" },
    { "<leader>uZ", function() Snacks.zen.zoom() end, desc = "Zoom" },
    { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Histórico de notificações" },
    { "<leader>uN", function() Snacks.notifier.hide() end, desc = "Descartar notificações" },

    -- Geral
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Fechar buffer" },
    { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    { "<C-_>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Próxima referência" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Referência anterior" },
  },

  init = function()
    -- Toggles registrados depois que o snacks carrega (eles aparecem com
    -- estado ligado/desligado no picker de keymaps).
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("relativenumber", { name = "Número relativo" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.scroll():map("<leader>us")
        Snacks.toggle.animate():map("<leader>ua")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
