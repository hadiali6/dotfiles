local os <const> = os
local require <const> = require

local wezterm <const> = require("wezterm")

local M <const> = {}

local function set_font_options(config)
    config.font = wezterm.font({
        family = "JetBrains Mono",
        harfbuzz_features = {
            "calt=0",
            "clig=0",
            "liga=0",
        },
    })
    config.font_size = 14.5
    config.window_padding = {
        left = "2cell",
        right = "2cell",
        top = "0.5cell",
        bottom = 0,
    }
    config.line_height = 1.25
    -- config.freetype_load_target = "VerticalLcd"
end

local function set_general_options(config)
    config.max_fps = 144
    config.switch_to_last_active_tab_when_closing_tab = true
    config.leader = { key = "RightAlt", mods = "ALT", timeout_milliseconds = 1000 }
    config.adjust_window_size_when_changing_font_size = false
    config.use_fancy_tab_bar = false
    config.enable_tab_bar = false
    -- config.disable_default_key_bindings = true
end

M.set_options = function(config)
    local is_wayland = os.getenv("WAYLAND_DISPLAY") and true or false
    set_font_options(config)
    set_general_options(config)
    config.enable_wayland = false
    config.front_end = "OpenGL"
    config.webgpu_power_preference = "HighPerformance"
    config.webgpu_force_fallback_adapter = false
end

return M
