local require = require
local table = table

local excluded_ft = require("config").indent_exlude_ft

return {
    -- {
    --     "lukas-reineke/indent-blankline.nvim",
    --     opts = {
    --         indent = {
    --             char = "│",
    --             tab_char = "│",
    --         },
    --         scope = { enabled = false },
    --         exclude = {
    --             buftypes = {
    --                 "terminal",
    --                 "nofile",
    --             },
    --             filetypes = excluded_ft,
    --         },
    --     },
    --     main = "ibl",
    -- },
    {
        "echasnovski/mini.indentscope",
        opts = {
            draw = {
                delay = 0,
                animation = function()
                    return 0
                end,
                priority = 200,
            },
            mappings = {
                object_scope = "<leader>zz",
                object_scope_with_border = "<leader>zx",
                goto_top = "[i",
                goto_bottom = "]i",
            },
            options = {
                border = "both",
                indent_at_cursor = true,
                try_as_border = true,
            },
            symbol = "│",
        },
    },
}
