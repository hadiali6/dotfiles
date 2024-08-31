local require = require
local swallow = require("module.swallow")

local M = {}

M.swallower = swallow:new({
    parent_filter_list = { "firefox", "Gimp", "Google-chrome" },
    child_filter_list = { "firefox", "Gimp", "Google-chrome" },
})

return M
