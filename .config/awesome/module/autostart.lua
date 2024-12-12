local ipairs = ipairs
local require = require
local string = string
local awful = require("awful")

local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

return function(programs)
    for _, app in ipairs(programs) do
        run_once(app)
    end
end
