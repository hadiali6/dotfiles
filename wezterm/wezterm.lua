local require = require
local os = os

local wezterm = require("wezterm")

local config = wezterm.config_builder()
do
    local keys = require("keys")
    keys.set_keys(config)
end
do
    local colors = require("colors")
    colors.set_colors(config, require("themes.ibmcarbon"))
end
do
    local options = require("options")
    options.set_options(config)
end

return config
