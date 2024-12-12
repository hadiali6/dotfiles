-- awesome_mode: api-level=4:screen=on

local pcall = pcall
local require = require
local collectgarbage = collectgarbage

pcall(require, "luarocks.loader")

do
    local naughty = require("naughty")
    naughty.connect_signal("request::display_error", function(message, startup)
        naughty.notification({
            urgency = "critical",
            title = "error" .. (startup and " during startup!" or "!"),
            message = message,
        })
    end)
end

require("awful.autofocus")
require("awful.hotkeys_popup.keys")
require("theme")
require("signal")
require("binds")
require("config.rules")

do
    local beautiful = require("beautiful")
    local volume_util = require("util.volume")
    local widgets = require("ui.wibar.module.volume")
    local icon_widget = widgets.icon_widget
    local text_widget = widgets.text_widget
    local percent_widget = widgets.percent_widget
    volume_util.get_volume_from_wpctl(
        function(volume_status, is_muted)
            if is_muted then
                icon_widget:set_image(beautiful.volume_icon_off)
                text_widget.visible = false
                percent_widget.visible = false
            else
                icon_widget:set_image(beautiful.volume_icon_on)
                text_widget:set_text(volume_status)
            end
        end
    )
end

collectgarbage("collect")
