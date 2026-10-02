-- Temas: lista das variações disponíveis, seletor com prévia ao vivo e
-- persistência da escolha em stdpath("data")/theme (fora do git).
local M = {}

M.default = "kanagawa-wave"

M.themes = {
  "catppuccin-latte", "catppuccin-frappe", "catppuccin-macchiato", "catppuccin-mocha",
  "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus",
  "everforest-dark-soft", "everforest-dark-medium", "everforest-dark-hard",
  "everforest-light-soft", "everforest-light-medium", "everforest-light-hard",
}

local file = vim.fn.stdpath("data") .. "/theme"

-- Aplica uma variação. Everforest usa variáveis em vez de nomes separados.
function M.apply(id)
  local bg, contrast = id:match("^everforest%-(%a+)%-(%a+)$")
  local ok, err
  if bg then
    vim.o.background = bg
    vim.g.everforest_background = contrast
    ok, err = pcall(vim.cmd.colorscheme, "everforest")
  else
    ok, err = pcall(vim.cmd.colorscheme, id)
  end
  if ok then
    M.current = id
  else
    vim.notify("Tema " .. id .. " falhou: " .. tostring(err), vim.log.levels.ERROR)
  end
  return ok
end

function M.save(id)
  vim.fn.writefile({ id }, file)
end

function M.load()
  local saved = vim.fn.filereadable(file) == 1 and vim.fn.readfile(file)[1] or nil
  if not (saved and vim.tbl_contains(M.themes, saved) and M.apply(saved)) then
    M.apply(M.default)
  end
end

-- Seletor do Telescope: mover a seleção já aplica o tema; <CR> salva;
-- <Esc> volta para o tema que estava antes.
function M.pick()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")

  local original = M.current or M.default
  local confirmed = false

  local function preview()
    local entry = state.get_selected_entry()
    if entry then M.apply(entry[1]) end
  end

  pickers.new(require("telescope.themes").get_dropdown({ layout_config = { height = 0.5 } }), {
    prompt_title = "Tema",
    finder = finders.new_table({ results = M.themes }),
    sorter = conf.generic_sorter({}),
    -- Começa no tema atual; ao filtrar, vai para o primeiro resultado.
    default_selection_index = math.max(1, vim.fn.index(M.themes, original) + 1),
    selection_strategy = "closest",
    on_complete = { function() preview() end }, -- prévia também ao digitar
    attach_mappings = function(bufnr, map)
      for _, key in ipairs({ "<C-n>", "<C-p>", "<Down>", "<Up>", "<C-j>", "<C-k>" }) do
        local action = (key == "<C-p>" or key == "<Up>" or key == "<C-k>")
            and actions.move_selection_previous or actions.move_selection_next
        map({ "i", "n" }, key, function() action(bufnr); preview() end)
      end
      map("n", "j", function() actions.move_selection_next(bufnr); preview() end)
      map("n", "k", function() actions.move_selection_previous(bufnr); preview() end)

      actions.select_default:replace(function()
        local entry = state.get_selected_entry()
        confirmed = true
        actions.close(bufnr)
        if entry and M.apply(entry[1]) then M.save(entry[1]) end
      end)

      -- Fechou sem confirmar: restaura.
      actions.close:enhance({
        post = function()
          if not confirmed then M.apply(original) end
        end,
      })
      return true
    end,
  }):find()
end

return M
