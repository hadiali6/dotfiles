local vim = vim
local require = require
-- return {
--     "saghen/blink.cmp",
--     lazy = false, -- lazy loading handled internally
--     -- optional: provides snippets for the snippet source
--     dependencies = "rafamadriz/friendly-snippets",
--     -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
--     -- build = 'cargo build --release',
--     -- If you use nix, you can build from source using latest nightly rust with:
--     -- build = 'nix run .#build-plugin',
--
--     ---@module 'blink.cmp'
--     ---@type blink.cmp.Config
--     opts = {
--         -- 'default' for mappings similar to built-in completion
--         -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
--         -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
--         -- see the "default configuration" section below for full documentation on how to define
--         -- your own keymap.
--         keymap = {
--             -- preset = "default",
--             ["<A-w>"] = { "select_and_accept", "fallback" },
--             ["<A-d>"] = { "select_next", "fallback" },
--             ["<A-e>"] = { "select_prev", "fallback" },
--             ["<A-q>"] = { "scroll_documentation_up", "fallback" },
--             ["<A-a>"] = { "scroll_documentation_down", "fallback" },
--             ["<A-x>"] = { "snippet_forward", "fallback" },
--             ["<A-z>"] = { "snippet_backward", "fallback" },
--         },
--
--         highlight = {
--             -- sets the fallback highlight groups to nvim-cmp's highlight groups
--             -- useful for when your theme doesn't support blink.cmp
--             -- will be removed in a future release, assuming themes add support
--             use_nvim_cmp_as_default = true,
--         },
--         -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
--         -- adjusts spacing to ensure icons are aligned
--         nerd_font_variant = "mono",
--
--         -- experimental auto-brackets support
--         -- accept = { auto_brackets = { enabled = true } }
--
--         -- experimental signature help support
--         -- trigger = { signature_help = { enabled = true } }
--     },
--     -- allows extending the enabled_providers array elsewhere in your config
--     -- without having to redefining it
--     opts_extend = { "sources.completion.enabled_providers" },
-- }
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },
                mapping = cmp.mapping.preset.insert({
                    ["<A-d>"] = cmp.mapping.select_next_item(),
                    ["<A-e>"] = cmp.mapping.select_prev_item(),
                    ["<A-q>"] = cmp.mapping.scroll_docs(4),
                    ["<A-a>"] = cmp.mapping.scroll_docs(-4),
                    ["<A-w>"] = cmp.mapping.confirm({ select = true }),
                    ["<A-Space>"] = cmp.mapping.complete({}),
                    ["<A-x>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<A-z>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
}
