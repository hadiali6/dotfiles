vim.pack.add({
    -- lsp configurations
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- lsp package manager
    { src = "https://github.com/mason-org/mason.nvim" },

    -- traslation between lspconfig lsp names and mason package names
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

    -- auto install mason packages
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },

    -- lsp progress bar
    { src = "https://github.com/j-hui/fidget.nvim" },

    -- lua lsp sources
    { src = "https://github.com/folke/lazydev.nvim" },

    -- formatting
    { src = "https://github.com/stevearc/conform.nvim" },

    -- linting
    { src = "https://github.com/mfussenegger/nvim-lint" },
})

local function log_fail(plugin_name)
    return vim.notify(string.format("%s didn't load", plugin_name), vim.log.levels.ERROR, { title = plugin_name })
end

local function blink_cmp_log_fail()
    log_fail("blink.cmp")
end

local function nvim_lint_log_fail()
    log_fail("nvim-lint")
end

local function mason_log_fail()
    log_fail("mason")
end

local function mason_tool_installer_log_fail()
    log_fail("mason-tool-installer")
end

local function conform_log_fail()
    log_fail("conform")
end

local function lazydev_log_fail()
    log_fail("lazydev")
end

local function fidget_log_fail()
    log_fail("fidget")
end

local toggle_state = false

vim.keymap.set("n", "<leader>lb", function()
    local ok, nvim_lint = pcall(require, "lint")
    if not ok then
        nvim_lint_log_fail()
        return
    end

    nvim_lint.linters_by_ft = {
        lua = { "selene" },
    }

    local ns = nvim_lint.get_namespace(nvim_lint.linters_by_ft[vim.bo.ft][1])
    if toggle_state == true then
        vim.diagnostic.reset(ns, vim.api.nvim_get_current_buf())
        toggle_state = false
    else
        nvim_lint.try_lint()
        toggle_state = true
    end
end, { desc = "Lint Buffer" })

local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
    conform_log_fail()
    return
end

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },

    default_format_opts = {
        lsp_format = "fallback",
    },

    format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
    },

    -- Set the log level. Use `:ConformInfo` to see the location of the log file.
    log_level = vim.log.levels.ERROR,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,
})

local lazydev_ok, lazydev = pcall(require, "lazydev")
if not lazydev_ok then
    lazydev_log_fail()
    return
end

lazydev.setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})

local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
    fidget_log_fail()
    return
end
fidget.setup({})

local function lsp(name)
    return { id = name, is_lsp = true, is_tool = false }
end
local function tool(name)
    return { id = name, is_lsp = false, is_tool = true }
end

local packages = {
    lsp("clangd"),

    lsp("lua_ls"),
    tool("stylua"),
    tool("selene"),

    lsp("bashls"),
    tool("shfmt"),

    lsp("jsonls"),

    lsp("zls"),

    lsp("gopls"),

    lsp("rust-analyzer"),

    lsp("jdtls"),

    lsp("pyright"),

    lsp("ts_ls"),
}

local mason_ensure_installed_packages = {}

for _, p in ipairs(packages) do
    table.insert(mason_ensure_installed_packages, p.id)
end

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
    mason_log_fail()
    return
end

mason.setup()

local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_ok then
    mason_tool_installer_log_fail()
    return
end

mason_tool_installer.setup({ ensure_installed = mason_ensure_installed_packages })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer_num = args.buf
        local map = function(mode, keymap, action, desc)
            vim.keymap.set(mode, keymap, action, { buffer = buffer_num, desc = desc })
        end

        map("n", "K", vim.lsp.buf.hover, "LSP Hover")
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>f", function()
            vim.lsp.buf.format({ async = true })
        end, "Format buffer")
    end,
})

for _, p in ipairs(packages) do
    if p.is_lsp then
        local lsp_config = vim.lsp.config[p.id]
        if lsp_config ~= nil then
            local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
            if not blink_cmp_ok then
                blink_cmp_log_fail()
                return
            end

            local capabilities = blink_cmp.get_lsp_capabilities(lsp_config.capabilities)
            vim.lsp.config(p.id, {
                capabilities = capabilities,
            })
        end
        vim.lsp.enable(p.id)
    end
end

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
