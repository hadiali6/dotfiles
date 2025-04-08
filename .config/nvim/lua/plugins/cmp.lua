return {
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*", -- release tag neceassary for downloading pre-built binaries

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                ["<M-C-e>"] = { "show", "show_documentation", "hide_documentation" },
                ["<M-h>"] = { "hide" },
                ["<M-w>"] = { "select_and_accept" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<M-e>"] = { "select_prev", "fallback_to_mappings" },
                ["<M-d>"] = { "select_next", "fallback_to_mappings" },

                ["<C-M-e>"] = { "scroll_documentation_up", "fallback" },
                ["<C-M-d>"] = { "scroll_documentation_down", "fallback" },

                ["M-x"] = { "snippet_forward", "fallback" },
                ["M-z"] = { "snippet_backward", "fallback" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },
            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                menu = {
                    draw = {
                        columns = {
                            -- We don't need label_description now because label and label_description are already
                            -- combined together in label by colorful-menu.nvim.
                            {
                                "label",
                                -- "label_description", -- uncomment when removing colorful-menu.nvim
                                gap = 1
                            },
                            { "kind" },
                        },

                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            }
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

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    {
        "xzbdmw/colorful-menu.nvim",

        opts = {
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
        },
    },
}
