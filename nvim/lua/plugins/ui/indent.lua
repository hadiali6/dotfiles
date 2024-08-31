local require = require
local table = table

local excluded_ft = require("config").ft

local M = {}

table.insert(M, {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
        indent = {
            char = "│",
            tab_char = "│",
        },
        scope = { enabled = false },
        exclude = {
            buftypes = {
                "terminal",
                "nofile",
            },
            filetypes = excluded_ft,
        },
    },
    main = "ibl",
})

table.insert(M, {
    "echasnovski/mini.indentscope",
    opts = {
        draw = {
            delay = 0,
            animation = function()
                return 0
            end,
            priority = 2,
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
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = excluded_ft,
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
})

return M
