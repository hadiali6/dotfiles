---@param opts? vim.lsp.get_clients.Filter
local function get_lsp_clients(opts)
    local ret = {} ---@type vim.lsp.Client[]
    ret = vim.lsp.get_clients(opts)
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param method string|string[]
local function has_method(buffer, method)
    if type(method) == "table" then
        for _, m in ipairs(method) do
            if has_method(buffer, m) then
                return true
            end
        end
        return false
    end

    method = method:find("/") and method or "textDocument/" .. method

    local clients = get_lsp_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end

    return false
end

---@type vim.api.keyset.create_autocmd
local lsp_on_attach_opts = {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
        local function map(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { desc = "LSP: " .. desc })
        end

        do
            local telescope_builtin = require("telescope.builtin")
            map("gd", telescope_builtin.lsp_definitions, "Goto Definition")
            map("gr", telescope_builtin.lsp_references, "Goto References")
            map("gI", telescope_builtin.lsp_implementations, "Goto Implementation")
            map("<leader>D", telescope_builtin.lsp_type_definitions, "Type Definition")
            map("<leader>ds", telescope_builtin.lsp_document_symbols, "Document Symbols")
            map("<leader>ws", telescope_builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")
            map("<leader>rn", vim.lsp.buf.rename, "Rename")
            map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
            map("K", vim.lsp.buf.hover, "Hover Documentation")
            map("gD", vim.lsp.buf.declaration, "Goto Declaration")
            if has_method(0, "documentHighlight") and Snacks.words.is_enabled() then
                map("]]", function()
                    Snacks.words.jump(vim.v.count1)
                end, "Next Reference")
                map("[[", function()
                    Snacks.words.jump(-vim.v.count1)
                end, "Previous Reference")
            end
        end

        do
            local client = vim.lsp.get_client_by_id(event.data.client_id)

            local ok, navic = pcall(require, "nvim-navic")
            if ok then
                navic.attach(client, event.buf)
            end

            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                map("<leader>tih", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                end, "Toggle Inlay Hints")
            end
        end
    end,
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
        -- "saghen/blink.cmp",
        {
            "folke/lazydev.nvim",
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
        { "Bilal2453/luvit-meta", lazy = true },
    },
    config = function()
        do
            local symbols = {
                Error = "!",
                Warn = "*",
                Hint = "?",
                Info = "@",
            }

            for name, icon in pairs(symbols) do
                local hl = "DiagnosticSign" .. name
                vim.fn.sign_define(hl, {
                    text = icon,
                    texthl = hl,
                })
            end
        end

        vim.api.nvim_create_autocmd("LspAttach", lsp_on_attach_opts)

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_capabilities = nil
        do
            local blink_exists, err_or_blink = pcall(require, "blink.cmp")
            local nvim_cmp_exists, err_or_nvim_cmp = pcall(require, "cmp_nvim_lsp")
            if blink_exists then
                cmp_capabilities = err_or_blink.get_lsp_capabilities()
            end
            if nvim_cmp_exists then
                cmp_capabilities = err_or_nvim_cmp.default_capabilities()
            end
        end
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_capabilities)

        local servers = {
            gopls = {},
            zls = {
                on_attach = function(_, buffer)
                    vim.api.nvim_create_autocmd("LspTokenUpdate", {
                        buffer = buffer,
                        callback = function(args)
                            local zls = vim.lsp.get_client_by_id(args.data.client_id)
                            if not zls then
                                return
                            end
                            if zls.name ~= "zls" then
                                return
                            end
                            ---@type STTokenRangeInspect
                            local token = args.data.token

                            local text = vim.api.nvim_buf_get_text(args.buf, token.line, token.start_col, token.line, token.end_col, {})[1]

                            if (text == "pub" or text == "inline" or text == "volotile") and token.type == "keyword" then
                                vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, "@keyword.modifier.zig")
                            end
                        end,
                    })
                end,
            },
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            },
        }

        require("mason").setup()

        local ensure_installed = vim.tbl_keys(servers or {})
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}
