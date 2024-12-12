local require = require
local table = table
local tostring = tostring

local wezterm = require("wezterm")
local act = wezterm.action
local act_callback = wezterm.action_callback

local M = {}

local function add_events()
    wezterm.on("toggle-tabbar", function(window, _)
        local overrides = window:get_config_overrides() or {}
        if not overrides.enable_tab_bar then
            wezterm.log_info("tab bar shown")
            overrides.enable_tab_bar = true
        else
            wezterm.log_info("tab bar hidden")
            overrides.enable_tab_bar = false
        end
        window:set_config_overrides(overrides)
    end)
end

M.set_keys = function(config)
    local mod = {
        ctrl = "CONTROL",
        shift = "SHIFT",
        super = "SUPER",
        alt = "ALT",
        leader = "LEADER",
    }
    config.keys = {}
    local function set_bind(mods, key, action)
        return table.insert(config.keys, #config.keys + 1, { mods = mods, key = key, action = action })
    end

    do
        local MAX_TABS = 9
        local MIN_TABS = 1

        for i = MIN_TABS - 1, MAX_TABS - 1, 1 do
            set_bind(mod.alt, tostring(i + 1), act.ActivateTab(i))
        end
    end

    set_bind(mod.alt, "z", act.EmitEvent("toggle-tabbar"))
    set_bind(mod.alt, "r", act.SpawnTab("CurrentPaneDomain"))
    set_bind(mod.alt, "f", act.CloseCurrentTab({ confirm = true }))
    set_bind(mod.alt, "Tab", act.ActivateLastTab)
    set_bind(mod.alt, "LeftArrow", act.ActivateTabRelative(-1))
    set_bind(mod.alt, "RightArrow", act.ActivateTabRelative(1))

    set_bind(mod.alt, "b", act.SplitVertical({ domain = "CurrentPaneDomain" }))
    set_bind(mod.alt, "n", act.SplitHorizontal({ domain = "CurrentPaneDomain" }))
    set_bind(mod.alt, "m", act.CloseCurrentPane({ confirm = true }))
    set_bind(mod.alt, "h", act.ActivatePaneDirection("Left"))
    set_bind(mod.alt, "j", act.ActivatePaneDirection("Down"))
    set_bind(mod.alt, "k", act.ActivatePaneDirection("Up"))
    set_bind(mod.alt, "l", act.ActivatePaneDirection("Right"))

    set_bind(
        "CTRL|SHIFT",
        "c",
        act_callback(function(w, p)
            local has_selection = w:get_selection_text_for_pane(p) ~= ""

            if has_selection then
                w:perform_action(act.CopyTo("Clipboard"), p)
            else
                w:perform_action(act.SendKey({ mods = "CTRL", key = "c" }), p)
            end
        end)
    )
    set_bind("CTRL|SHIFT", "v", act.PasteFrom("Clipboard"))
    -- set_bind("CTRL", "f", act.Search("CurrentSelectionOrEmptyString"))
    add_events()
end

return M
