local function augroup(name)
    return vim.api.nvim_create_augroup("config-" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup("highlight-yank"),
    callback = function()
        vim.hl.on_yank({
            higroup = "MoreMsg",
            on_visual = true,
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap-spell"),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

local function map(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { desc = "LSP: " .. desc })
end


vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp-attach"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        assert(client)

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
            if
                client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and
                Snacks.words.is_enabled()
            then
                map("]]", function()
                    Snacks.words.jump(vim.v.count1)
                end, "Next Reference")
                map("[[", function()
                    Snacks.words.jump(-vim.v.count1)
                end, "Previous Reference")
            else
            end
        end

        do
            local ok, navic = pcall(require, "nvim-navic")
            if ok then
                navic.attach(client, args.buf)
            end

            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                map("<leader>tih", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }))
                end, "Toggle Inlay Hints")
            end
        end
    end,
})
