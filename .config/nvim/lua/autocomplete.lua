vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/xzbdmw/colorful-menu.nvim" },
    { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
})

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if name == "LuaSnip" and (kind == "install" or kind == "update") then
        vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
        vim.notify("LuaSnip: jsregexp built successfully", vim.log.levels.INFO)
    end
end

vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

local group = vim.api.nvim_create_augroup("BlinkCmpLazyLoad", { clear = true })

local function blink_cmp_log_fail()
    return vim.notify("blink.cmp didn't load", vim.log.levels.ERROR, { title = "blink.cmp" })
end

local function colorful_menu_log_fail()
    return vim.notify("colorful-menu didn't load", vim.log.levels.ERROR, { title = "colorful-menu" })
end

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    group = group,
    once = true,
    callback = function()
        local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
        if not blink_cmp_ok then
            blink_cmp_log_fail()
            return
        end

        local colorful_menu_ok, colorful_menu = pcall(require, "colorful-menu")
        if not colorful_menu_ok then
            colorful_menu_log_fail()
            return
        end

        blink_cmp.setup(
            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            {
                keymap = {
                    ["<M-C-e>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<M-h>"] = { "hide" },
                    ["<M-w>"] = { "accept", "fallback" },

                    ["<Up>"] = { "select_prev", "fallback" },
                    ["<Down>"] = { "select_next", "fallback" },
                    ["<M-e>"] = { "select_prev", "fallback_to_mappings" },
                    ["<M-d>"] = { "select_next", "fallback_to_mappings" },

                    ["<C-M-e>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-M-d>"] = { "scroll_documentation_down", "fallback" },

                    ["<M-x>"] = { "snippet_forward", "fallback" },
                    ["<M-z>"] = { "snippet_backward", "fallback" },

                    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
                },

                appearance = { nerd_font_variant = "mono" },

                completion = {
                    menu = {
                        draw = {
                            columns = {
                                -- We don't need label_description now because label and label_description are already
                                -- combined together in label by colorful-menu.nvim.
                                {
                                    "label",
                                    -- "label_description", -- uncomment when removing colorful-menu.nvim
                                    gap = 1,
                                },
                                { "kind" },
                            },

                            components = {
                                label = {
                                    text = function(ctx)
                                        return colorful_menu.blink_components_text(ctx)
                                    end,
                                    highlight = function(ctx)
                                        return colorful_menu.blink_components_highlight(ctx)
                                    end,
                                },
                            },
                        },
                    },

                    documentation = { auto_show = false },
                },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },

                signature = { enabled = true },
                snippets = { preset = "luasnip" },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                --
                -- See the fuzzy documentation for more information
                fuzzy = { implementation = "prefer_rust_with_warning" },
            }
        )
    end,
})

require("colorful-menu").setup({
    ls = {
        lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = "@comment",
        },
        gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
        },
        -- for lsp_config or typescript-tools
        ts_ls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
        },
        vtsls = {
            -- false means do not include any extra info,
            -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
            extra_info_hl = "@comment",
        },
        ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
        },
        clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = "@comment",
            -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
            preserve_type_when_truncate = true,
        },
        zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
        },
        roslyn = {
            extra_info_hl = "@comment",
        },
        dartls = {
            extra_info_hl = "@comment",
        },
        -- The same applies to pyright/pylance
        basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
        },
        -- If true, try to highlight "not supported" languages.
        fallback = true,
        -- this will be applied to label description for unsupport languages
        fallback_extra_info_hl = "@comment",
    },
    -- If the built-in logic fails to find a suitable highlight group for a label,
    -- this highlight is applied to the label.
    fallback_highlight = "@variable",
    -- If provided, the plugin truncates the final displayed text to
    -- this width (measured in display cells). Any highlights that extend
    -- beyond the truncation point are ignored. When set to a float
    -- between 0 and 1, it'll be treated as percentage of the width of
    -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
    -- Default 60.
    max_width = 60,
})
