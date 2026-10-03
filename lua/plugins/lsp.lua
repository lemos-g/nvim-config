-- LSP só para ler: navegação, hover, diagnósticos e inlay hints. Sem
-- formatador, autocomplete, code action ou rename — quem escreve é a IA.
--
-- Usa a API nativa do 0.11+ (vim.lsp.config / vim.lsp.enable); o
-- nvim-lspconfig só fornece as configs padrão em lsp/*.lua. O Mason instala os
-- servidores (precisa de node/npm) e põe o bin dele no PATH.

-- Fonte única dos servidores: o Mason instala e o vim.lsp.enable liga.
local servers = { "vtsls", "eslint", "tailwindcss", "lua_ls" }

-- Inlay hints que o vtsls calcula; ficam escondidos até <leader>uh
-- (Snacks.toggle.inlay_hints, em lua/plugins/snacks.lua).
local inlay_hints = {
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

-- Mapas padrão do 0.11+ (grn rename, gra code action, grr/gri/grt/grx). Sem
-- eles, `gr` (referências) responde na hora em vez de esperar o timeoutlen.
local default_maps = {
  { "n", "grn" }, { { "n", "x" }, "gra" }, { "n", "grr" },
  { "n", "gri" }, { "n", "grt" }, { "n", "grx" },
}

local function on_attach(ev)
  local function map(lhs, rhs, desc, opts)
    vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, opts or {}))
  end
  -- stylua: ignore start
  map("gd", function() Snacks.picker.lsp_definitions() end, "Definição")
  map("gr", function() Snacks.picker.lsp_references() end, "Referências", { nowait = true })
  map("gI", function() Snacks.picker.lsp_implementations() end, "Implementações")
  map("gy", function() Snacks.picker.lsp_type_definitions() end, "Definição de tipo")
  map("K", function() vim.lsp.buf.hover() end, "Hover")
  map("<leader>cd", function() vim.diagnostic.open_float() end, "Diagnóstico da linha")
  -- stylua: ignore end
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    vim.lsp.config("vtsls", {
      settings = {
        vtsls = {
          -- TypeScript do node_modules do projeto, igual ao typecheck. A raiz
          -- (pnpm-lock.yaml) é a do monorepo.
          autoUseWorkspaceTsdk = true,
          experimental = { maxInlayHintLength = 30 },
        },
        typescript = {
          inlayHints = inlay_hints,
          tsserver = { maxTsServerMemory = 8192 },
        },
        javascript = { inlayHints = inlay_hints },
      },
    })

    -- Monorepo: cada app tem o seu eslint.config.mjs.
    vim.lsp.config("eslint", {
      settings = { workingDirectories = { mode = "auto" } },
    })

    -- API do Neovim (vim.*) e o global Snacks sem avisos falsos.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          },
          diagnostics = { globals = { "Snacks" } },
          telemetry = { enable = false },
        },
      },
    })

    require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = false })
    vim.lsp.enable(servers)

    local sev = vim.diagnostic.severity
    vim.diagnostic.config({
      severity_sort = true,
      underline = false,
      update_in_insert = false,
      -- A statuscolumn do snacks desenha os sinais.
      signs = {
        text = {
          [sev.ERROR] = "",
          [sev.WARN] = "",
          [sev.INFO] = "",
          [sev.HINT] = "󰌵",
        },
      },
      virtual_text = { spacing = 2, prefix = "●", source = false },
      float = { source = "if_many" }, -- borda via winborder
    })

    for _, m in ipairs(default_maps) do
      pcall(vim.keymap.del, m[1], m[2])
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("config.lsp", { clear = true }),
      callback = on_attach,
    })
  end,
}
