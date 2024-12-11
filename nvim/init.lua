local require = require
local pcall = pcall

require("options")
require("autocmds")

-- plugins
require("lazy_bootstrap")

-- set colorscheme
pcall(vim.cmd.colorscheme, require("config").theme)
require("color_override")

-- must be after lazy_bootstrap
require("keymaps")
