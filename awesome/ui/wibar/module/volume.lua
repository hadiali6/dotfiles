local require = require
local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local volume_util = require("util.volume")

local text_widget = wibox.widget.textbox()
local percent_widget = wibox.widget.textbox("%")
local icon_widget = wibox.widget.imagebox()
local volume_widget = wibox.widget({
    widget = wibox.container.margin,
    margins = {
        top    = beautiful.wibar_widget_margin,
        bottom = beautiful.wibar_widget_margin,
        right  = beautiful.wibar_widget_margin,
        left   = beautiful.wibar_widget_margin,
    },
    {
        widget = wibox.container.background,
        bg = beautiful.wibar_widget_bg,
        fg = beautiful.wibar_widget_fg,
        border_color = beautiful.wibar_widget_border_color,
        border_width = beautiful.wibar_widget_border_width,
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.textbox(" "),
            icon_widget,
            text_widget,
            percent_widget,
            wibox.widget.textbox(" "),
        },
    }
})

-- volume_widget.buttons = {
--     awful.button(nil, 1,
--         function()
--             awful.spawn(volume_util.commands.togglemute, false)
--             volume_widget:emit_signal("togglemute")
--         end
--     ),
--     awful.button(nil, 3,
--         function()
--             awful.spawn(volume_util.commands.togglemute, false)
--             volume_widget:emit_signal("togglemute")
--         end
--     ),
--     awful.button(nil, 4,
--         function()
--             awful.spawn.with_shell(volume_util.commands.unmute)
--             awful.spawn.with_shell(volume_util.commands.increase(MAX_VOLUME / 100, 1))
--             volume_widget:emit_signal("raise", 1)
--         end
--     ),
--     awful.button(nil, 5,
--         function()
--             awful.spawn.with_shell(volume_util.commands.unmute)
--             awful.spawn.with_shell(volume_util.commands.decrease(1))
--             volume_widget:emit_signal("lower", 1)
--         end
--     ),
-- }

-- ---@param amount number
-- local increase_volume = function(amount)
--     if text_widget.text + amount >= MAX_VOLUME then
--         text_widget:set_text(MAX_VOLUME)
--     else
--         text_widget:set_text(text_widget.text + amount)
--     end
-- end
--
-- ---@param amount number
-- local decrease_volume = function(amount)
--     if text_widget.text - amount <= MIN_VOLUME then
--         text_widget:set_text(MIN_VOLUME)
--     else
--         text_widget:set_text(text_widget.text - amount)
--     end
-- end

-- local signal_callbacks = {
--     raise = function(_, amount)
--         increase_volume(amount)
--         if not text_widget.visible then
--             icon_widget:set_image(beautiful.volume_icon_on)
--             text_widget.visible = true
--             percent_widget.visible = true
--         end
--     end,
--     lower = function(_, amount)
--         decrease_volume(amount)
--         if not text_widget.visible then
--             icon_widget:set_image(beautiful.volume_icon_on)
--             text_widget.visible = true
--             percent_widget.visible = true
--         end
--     end,
--     togglemute = function(_)
--         if text_widget.visible then
--             icon_widget:set_image(beautiful.volume_icon_off)
--             text_widget.visible = false
--             percent_widget.visible = false
--         else
--             volume_util.get_volume_from_wpctl(function(current_volume)
--                 text_widget:set_text(current_volume)
--             end)
--             icon_widget:set_image(beautiful.volume_icon_on)
--             text_widget.visible = true
--             percent_widget.visible = true
--         end
--     end,
--     update = function (_)
--         volume_util.get_volume_from_wpctl(function(volume_status, is_muted)
--             if is_muted then
--                 icon_widget:set_image(beautiful.volume_icon_off)
--                 text_widget.visible = false
--                 percent_widget.visible = false
--             else
--                 -- icon_widget:set_image(beautiful.volume_icon_on)
--                 text_widget:set_text(volume_status)
--             end
--         end)
--     end,
-- }

-- Initialize widget.
-- do
--     volume_util.get_volume_from_wpctl(
--         function(volume_status, is_muted)
--             if is_muted then
--                 icon_widget:set_image(beautiful.volume_icon_off)
--                 text_widget.visible = false
--                 percent_widget.visible = false
--             else
--                 icon_widget:set_image(beautiful.volume_icon_on)
--                 text_widget:set_text(volume_status)
--             end
--         end
--     )
-- end

return {
    full_widget = volume_widget,
    text_widget = text_widget,
    icon_widget = icon_widget,
    percent_widget = percent_widget,
}
