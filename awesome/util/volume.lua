local require = require
local string = string
local math = math
local awful = require("awful")
local M = {}

---@param limit number
---@param amount number
M.increase = function(limit, amount)
    return string.format(
        "wpctl set-volume -l %.1f @DEFAULT_AUDIO_SINK@ %d%%+",
        limit, amount)
end

---@param amount number
M.decrease = function(amount)
    return string.format(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ %d%%-",
        amount)
end

M.toggle_mute       = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
M.unmute            = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
M.get_volume_status = "wpctl get-volume @DEFAULT_AUDIO_SINK@"

---Given a function callback, gets current volume and mute status from wpctl within the shell.
---@param callback function: Arbritary function which passes in the volume and mute status.
M.get_volume_from_wpctl = function(callback)
    awful.spawn.easy_async(
        M.get_volume_status,
        function(stdout)
            local volume = math.floor(stdout:match("Volume:%s+(%d+.%d+)") * 100 + 0.5)
            local is_muted = stdout:match("MUTED") and true or false
            callback(volume, is_muted)
        end
    )
end

return M
