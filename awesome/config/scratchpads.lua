local require = require
local scratchpad = require("module.scratchpad")

---@type group
local my_pads = scratchpad.group:new({
    id = "1",
})

my_pads:add_scratchpad(scratchpad:new({
    id = "1",
    command = "alacritty",
    group = my_pads,
    client_options = {
        floating = true,
    },
    scratchpad_options = {
        reapply_options = true,
        only_one        = true,
    },
}))

my_pads:add_scratchpad(scratchpad:new({
    command = "alacritty",
    id = "2",
    group = my_pads,
    client_options = {
        floating = true,
    },
    scratchpad_options = {
        reapply_options = true,
        only_one        = true,
    },
}))

my_pads:add_scratchpad(scratchpad:new({
    command = "firefox",
    id = "3",
    group = my_pads,
    client_options = {
        floating = true,
    },
    scratchpad_options = {
        reapply_options = true,
        only_one        = true,
    },
}))

my_pads:add_scratchpad(scratchpad:new({
    command = "neovide",
    id = "4",
    group = my_pads,
    client_options = {
        floating = true,
    },
    scratchpad_options = {
        reapply_options = true,
        only_one        = true,
    },
}))

return my_pads
