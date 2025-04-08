local function zls_on_attach(_, buffer)
    vim.api.nvim_create_autocmd("LspTokenUpdate", {
        buffer = buffer,
        callback = function(args)
            local zls = vim.lsp.get_client_by_id(args.data.client_id)
            if not zls or zls.name ~= "zls" then
                return
            end

            ---@type STTokenRangeInspect
            local token = args.data.token
            if token.type ~= "keyword" then
                return
            end

            local text = vim.api.nvim_buf_get_text(
                args.buf,
                token.line,
                token.start_col,
                token.line,
                token.end_col,
                {}
            )[1]

            for _, keyword in ipairs({ "pub", "inline", "volotile", "extern", "packed" }) do
                if text == keyword then
                    vim.lsp.semantic_tokens.highlight_token(
                        token,
                        args.buf,
                        args.data.client_id,
                        "@keyword.modifier.zig"
                    )
                end
            end
        end,
    })
end

return {
    {
        "williamboman/mason.nvim",
        dependencies = { "mason-org/mason-registry" },
        opts = {
            ui = {
                icons = {
                    package_installed = "O",
                    package_pending = "O",
                    package_uninstalled = "O",
                },
            },
        },
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                lua_ls = {},
                zls = {
                    on_attach = zls_on_attach,
                },
                ts_ls = {},
                clangd = {},
                jdtls = {},
            },
        },
        config = function(_, opts)
            vim.diagnostic.config({
                jump = { float = true },
                signs = {
                    active = true,
                    text = {
                        [vim.diagnostic.severity.ERROR] = "!",
                        [vim.diagnostic.severity.WARN] = "*",
                        [vim.diagnostic.severity.INFO] = "@",
                        [vim.diagnostic.severity.HINT] = "?",
                    },
                },
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, prefix = "■" },
                severity_sort = true,
            })

            local lspconfig = require("lspconfig")
            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                lspconfig[server].setup(config)
            end
        end,
    },

    {
        "j-hui/fidget.nvim",
        opts = {},
    },

    {
        "folke/lazydev.nvim",
        dependencies = {
            { "Bilal2453/luvit-meta", lazy = true },
        },
        ft = "lua",

        opts = {
            enabled = function(root_dir)
                return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
            end,

            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
}
