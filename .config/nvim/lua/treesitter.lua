vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "90cd658" },
})
local function nvim_treesitter_log_fail()
    return vim.notify("nvim-treesitter didn't load", vim.log.levels.ERROR, { title = "Treesitter" })
end

local treesitter_cli_not_found_logged = false
local function treesitter_cli_not_found()
    if not treesitter_cli_not_found_logged then
        vim.notify("tree-sitter CLI not found. Parsers cannot be installed", vim.log.levels.ERROR, { title = "Treesitter" })
        treesitter_cli_not_found_logged = true
    end
end

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function()
        local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
        if not ok then
            nvim_treesitter_log_fail()
            return
        end

        nvim_treesitter.update()
    end,
})

local default_parsers = {
    "css",
    "comment",
    "markdown",
    "markdown_inline",
    "regex",
    "vimdoc",
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    callback = function()
        local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
        if not ok then
            nvim_treesitter_log_fail()
            return
        end

        if vim.fn.executable("tree-sitter") ~= 1 then
            treesitter_cli_not_found()
            return
        end

        nvim_treesitter.setup()
        nvim_treesitter.install(default_parsers)
    end,

    once = true,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local highlight = function(bufnr, lang)
            local was_parser_loaded = vim.treesitter.language.add(lang)
            if not was_parser_loaded then
                return vim.notify(string.format("Treesitter cannot load parser for language: %s", lang), vim.log.levels.INFO, { title = "Treesitter" })
            end
            vim.treesitter.start(bufnr)
        end

        local file_type = vim.bo.filetype
        local buffer_type = vim.bo.buftype
        local buffer_number = args.buf

        if buffer_type ~= "" then
            return
        end

        local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
        if not ok then
            nvim_treesitter_log_fail()
            return
        end

        -- folds
        if file_type == "javascriptreact" or file_type == "typescriptreact" then
            vim.opt_local.foldmethod = "indent"
        else
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt_local.foldenable = false
        end

        -- indents
        if not vim.tbl_contains({ "python", "html", "yaml", "markdown", "zig" }, file_type) then
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end

        -- parser handling
        if vim.fn.executable("tree-sitter") ~= 1 then
            treesitter_cli_not_found()
            return
        end

        if not vim.treesitter.language.get_lang(file_type) then
            return
        end

        if vim.list_contains(nvim_treesitter.get_installed(), file_type) then
            highlight(buffer_number, file_type)
        elseif vim.list_contains(nvim_treesitter.get_available(), file_type) then
            nvim_treesitter.install(file_type):await(function()
                highlight(buffer_number, file_type)
            end)
        end
    end,
})
