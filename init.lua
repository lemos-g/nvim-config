-- Ordem importa: options define o leader antes do lazy carregar os plugins;
-- o tema é aplicado logo depois, antes do dashboard e da UI aparecerem.
require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.theme").setup()
