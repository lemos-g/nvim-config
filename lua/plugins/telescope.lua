-- Telescope: busca difusa de arquivos, texto (ripgrep), símbolos e mais.
-- telescope-fzf-native acelera a ordenação (compilado com make).
return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Arquivos" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Texto no projeto (grep)" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Palavra sob o cursor", mode = { "n", "x" } },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers abertos" },
    { "<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<CR>", desc = "Recentes" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Ajuda" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Atalhos" },
    { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buscar no buffer" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Símbolos do arquivo" },
    { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Símbolos do projeto" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnósticos" },
    { "<leader>fR", "<cmd>Telescope resume<CR>", desc = "Retomar última busca" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        path_display = { "truncate" },
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
      pickers = {
        find_files = { hidden = true, file_ignore_patterns = { "^.git/", "node_modules/" } },
      },
    })
    require("telescope").load_extension("fzf")
  end,
}
