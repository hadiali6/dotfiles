local require = require
local awful = require("awful")
local mod = require("binds.mod")
local scratchpads = require("config.scratchpads").scratchpads
local swallow = require("config.swallow")

return {
    awful.key({ mod.super }, "w", function()
        swallow.swallower:toggle()
    end),
    awful.key({ mod.super }, "F1", function()
        scratchpads[1]:toggle()
    end),
    awful.key({ mod.super }, "F2", function()
        scratchpads[2]:toggle()
    end),
    awful.key({ mod.super }, "F3", function()
        scratchpads[3]:toggle()
    end),
    awful.key({ mod.super }, "F4", function()
        scratchpads[4]:toggle()
    end),
}
