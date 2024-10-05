local vim = vim

local ipairs = ipairs
local package = package
local table = table
local require = require

local function cmp_visible()
    ---@module "cmp"
    local cmp = package.loaded["cmp"]
    return cmp and cmp.core.view:visible()
end

local words_ns = vim.api.nvim_create_namespace("vim_lsp_references")

---@alias LspWord { from: { [1]:number, [2]:number }, to: { [1]:number, [2]:number } } 1-0 indexed

---@return LspWord[] words, number? current
local function get_words()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local current, ret = nil, {} ---@type number?, LspWord[]
    for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, words_ns, 0, -1, { details = true })) do
        local w = {
            from = { extmark[2] + 1, extmark[3] },
            to = { extmark[4].end_row + 1, extmark[4].end_col },
        }
        ret[#ret + 1] = w
        if cursor[1] >= w.from[1] and cursor[1] <= w.to[1] and cursor[2] >= w.from[2] and cursor[2] <= w.to[2] then
            current = #ret
        end
    end
    return ret, current
end

---@param count number
---@param cycle? boolean
local function word_jump(count, cycle)
    local words, idx = get_words()
    if not idx then
        return
    end
    idx = idx + count
    if cycle then
        idx = (idx - 1) % #words + 1
    end
    local target = words[idx]
    if target then
        vim.api.nvim_win_set_cursor(0, target.from)
    end
end

---@alias vim_autocmd_callback_args { id: number, event: string, group: number?, match: string, buf: number, file: string, data: any }

---@type vim.api.keyset.create_autocmd
local lsp_opts = {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),

    ---@param lsp_attach_args vim_autocmd_callback_args
    callback = function(lsp_attach_args)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = lsp_attach_args.buf, desc = "LSP: " .. desc })
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
            map("]]", function()
                word_jump(vim.v.count1)
            end, "Next Reference")
            map("[[", function()
                word_jump(-vim.v.count1)
            end, "Prev Reference")
            map("<a-o>", function()
                word_jump(vim.v.count1, true)
            end, "Next Reference")
            map("<a-p>", function()
                word_jump(-vim.v.count1, true)
            end, "Prev Reference")
        end

        local client = vim.lsp.get_client_by_id(lsp_attach_args.data.client_id)

        if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
                group = vim.api.nvim_create_augroup("lsp_word_" .. lsp_attach_args.buf, { clear = true }),
                buffer = lsp_attach_args.buf,

                ---@param cursor_event_args vim_autocmd_callback_args
                callback = function(cursor_event_args)
                    if not ({ get_words() })[2] then
                        if cursor_event_args.event:find("CursorMoved") then
                            vim.lsp.buf.clear_references()
                        elseif not cmp_visible() then
                            vim.lsp.buf.document_highlight()
                        end
                    end
                end,
            })
        end

        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "Toggle Inlay Hints")
        end
    end,
}

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opts = {} },
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

            vim.api.nvim_create_autocmd("LspAttach", lsp_opts)

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
                zls = {},
                clangd = {},
                pyright = {},
            }

            require("mason").setup()
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "clang-format",
            })
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
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        enabled = function()
            local function is_within_directory(file_dir, base_dir)
                if not base_dir:match("/$") then
                    base_dir = base_dir .. "/"
                end
                if not file_dir:match("/$") then
                    file_dir = file_dir .. "/"
                end
                return file_dir:sub(1, #base_dir) == base_dir
            end
            return
                is_within_directory(vim.fn.expand("%:p"), vim.fn.stdpath("config"))
                or is_within_directory(vim.fn.expand("%:p"), vim.fn.stdpath("data"))
        end,
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0,
            })
        end,
    },
}
