---@param callback_on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
local function on_attach(callback_on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then
                return callback_on_attach(client, buffer)
            end
        end,
    })
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = true,
    },

    {
        "EdenEast/nightfox.nvim",
        lazy = true,
    },

    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 50,
                    tabline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    "filename",
                    {
                        function()
                            local navic_ok, navic = pcall(require, "nvim-navic")
                            if navic_ok then
                                return navic.get_location()
                            end
                        end,
                        function()
                            local navic_ok, navic = pcall(require, "nvim-navic")
                            if navic_ok then
                                return navic.is_available()
                            end
                        end,
                    },
                },
                lualine_x = {
                    "filetype",
                },
                lualine_y = { "%l:%c" },
                lualine_z = { { "progress" }, { "%L" } },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        },
    },

    {
        "SmiteshP/nvim-navic",
        init = function()
            vim.cmd("highlight! link NavicText @diff.plus")
            vim.g.navic_silence = true
            on_attach(function(client, buffer)
                if client.supports_method("textDocument/documentSymbol") then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = {
            separator = " > ",
            highlight = true,
            depth_limit = 10,
            depth_limit_indicator = "..",
            lazy_update_context = true,
            icons = {
                File = "",
                Module = "",
                Namespace = "",
                Package = "",
                Class = "",
                Method = "",
                Property = "",
                Field = "",
                Constructor = "",
                Enum = "",
                Interface = "",
                Function = "",
                Variable = "",
                Constant = "",
                String = "",
                Number = "",
                Boolean = "",
                Array = "",
                Object = "",
                Key = "",
                Null = "",
                EnumMember = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            },
            format_text = function(text)
                return text
            end,
        },
    },

    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = false,         -- #RGB hex codes
                RRGGBB = true,       -- #RRGGBB hex codes
                names = false,       -- "Name" codes like Blue or blue
                RRGGBBAA = true,     -- #RRGGBBAA hex codes
                AARRGGBB = true,     -- 0xAARRGGBB hex codes
                rgb_fn = false,      -- CSS rgb() and rgba() functions
                hsl_fn = false,      -- CSS hsl() and hsla() functions
                css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                tailwind = false,                               -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
                virtualtext = "■",
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = false,
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {},
        },
    },

    {
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")
            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    -- lua = "rainbow-blocks",
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterCyan",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterRed",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterGreen",
                },
            }
            vim.keymap.set("n", "<leader>rr", function()
                rainbow_delimiters.toggle(vim.api.nvim_get_current_buf())
            end)
        end,
    },

    {
        "echasnovski/mini.indentscope",
        opts = {
            draw = {
                delay = 0,
                animation = function()
                    return 0
                end,
                priority = 1,
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
