local require = require

local awful = require("awful")
local beautiful = require("beautiful")
local volume_util = require("util.volume")
local mod = require("binds.mod")
local widgets = require("ui.wibar.module.volume")
local text_widget = widgets.text_widget
local icon_widget = widgets.icon_widget
local percent_widget = widgets.percent_widget

local MAX_VOLUME = 100
local MIN_VOLUME = 0
local LIMIT = MAX_VOLUME / 100

local function increase_volume(amount)
    awful.spawn(volume_util.unmute, false)
    awful.spawn.easy_async(
        volume_util.increase(LIMIT, amount),
        function()
            if text_widget.text + amount >= MAX_VOLUME then
                text_widget:set_text(MAX_VOLUME)
            else
                text_widget:set_text(text_widget.text + amount)
            end
            if not text_widget.visible then
                icon_widget:set_image(beautiful.volume_icon_on)
                text_widget.visible = true
                percent_widget.visible = true
            end
        end
    )
end

local function decrease_volume(amount)
    awful.spawn(volume_util.unmute, false)
    awful.spawn.easy_async(
        volume_util.decrease(amount),
        function()
            if text_widget.text - amount <= MIN_VOLUME then
                text_widget:set_text(MIN_VOLUME)
            else
                text_widget:set_text(text_widget.text - amount)
            end
            if not text_widget.visible then
                icon_widget:set_image(beautiful.volume_icon_on)
                text_widget.visible = true
                percent_widget.visible = true
            end
        end
    )
end

---Given a function callback, gets current volume and mute status from wpctl within the shell.
---@param callback function: Arbritary function which passes in the volume and mute status.
local get_volume_from_wpctl = function(callback)
    awful.spawn.easy_async(
        volume_util.get_volume_status,
        function(stdout)
            local volume = math.floor(stdout:match("Volume:%s+(%d+.%d+)") * 100 + 0.5)
            local is_muted = stdout:match("MUTED") and true or false
            callback(volume, is_muted)
        end
    )
end

local function toggle_mute()
    awful.spawn(volume_util.toggle_mute, false)
    if text_widget.visible then
        icon_widget:set_image(beautiful.volume_icon_off)
        text_widget.visible = false
        percent_widget.visible = false
    else
        get_volume_from_wpctl(function(current_volume)
            text_widget:set_text(current_volume)
        end)
        icon_widget:set_image(beautiful.volume_icon_on)
        text_widget.visible = true
        percent_widget.visible = true
    end
end

awful.keygrabber({
    export_keybindings = true,
    start_callback = function(keygrabber)
        awful.spawn("xset r rate 660 25", false)
    end,
    stop_callback = function(self, stop_key, stop_mods, sequence)
        awful.spawn("xset r rate 300 50", false)
    end,
    keyreleased_callback = function(self, mod_key, key, event)
        self:stop()
    end,
    allowed_keys = { "XF86AudioRaiseVolume", "XF86AudioLowerVolume", "XF86AudioMute" },
    stop_event = "release",
    keybindings = {
        awful.key({}, "XF86AudioRaiseVolume",
            function()
                increase_volume(1)
            end,
            { description = "increase volume by 1%", group = "custom" }
        ),
        awful.key({}, "XF86AudioLowerVolume",
            function()
                decrease_volume(1)
            end,
            { description = "decrease volume by 1%", group = "custom" }
        ),
        awful.key({ mod.ctrl, },
            "XF86AudioRaiseVolume",
            function()
                increase_volume(5)
            end,
            { description = "increase volume by 5%", group = "custom" }
        ),
        awful.key({ mod.ctrl, }, "XF86AudioLowerVolume",
            function()
                decrease_volume(5)
            end,
            { description = "decrease volume by 5%", group = "custom" }
        ),
        awful.key({}, "XF86AudioMute",
            toggle_mute,
            { description = "toggle mute", group = "audio" }
        ),
        awful.key({ mod.ctrl, }, "XF86AudioMute", toggle_mute),
    }
})

return {
    awful.key({}, "XF86AudioPlay",
        function() awful.spawn("playerctl play-pause", false) end,
        { description = "playerctl play/pause toggle", group = "custom" }
    ),
    awful.key({}, "XF86AudioNext",
        function() awful.spawn("playerctl next", false) end,
        { description = "playerctl next", group = "custom" }
    ),
    awful.key({}, "XF86AudioPrev",
        function() awful.spawn("playerctl previous", false) end,
        { description = "playerctl previous", group = "custom" }
    ),
}
