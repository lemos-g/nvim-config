-- LSP: nvim-lspconfig traz as configs dos servidores, mason instala os
-- binários e mason-lspconfig liga os dois (instala e habilita sozinho).
local servers = { "ts_ls", "eslint", "tailwindcss", "jsonls", "lua_ls" }

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- Capacidades extras do autocompletar valem para todos os servidores.
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

    -- lua_ls: entender a API do Neovim ao editar esta config.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
        },
      },
    })

    -- tailwindcss: só as linguagens do stack (a lista padrão inclui dezenas
    -- de filetypes que o Neovim nem conhece e poluem o :checkhealth).
    vim.lsp.config("tailwindcss", {
      filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    })

    require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = true })

    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = { spacing = 2, source = "if_many" },
      float = { border = "rounded", source = true },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
    })

    -- Atalhos só nos buffers com LSP. Os padrões do Neovim continuam valendo:
    -- K (hover), [d ]d (diagnósticos), <C-s> (assinatura no insert).
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(args)
        local tb = require("telescope.builtin")
        local function map(lhs, rhs, desc, mode)
          vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map("gd", tb.lsp_definitions, "Ir para definição")
        map("grr", tb.lsp_references, "Referências")
        map("gri", tb.lsp_implementations, "Implementações")
        map("grt", tb.lsp_type_definitions, "Definição do tipo")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("<leader>cr", vim.lsp.buf.rename, "Renomear símbolo")
      end,
    })
  end,
}
