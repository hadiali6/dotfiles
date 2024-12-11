local vim = vim

local function augroup(name)
    return vim.api.nvim_create_augroup("main-" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = augroup("highlight-yank"),
    callback = function()
        vim.highlight.on_yank({
            higroup = "MoreMsg",
            on_visual = true,
        })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "*.txt", "*.tex", "*.typ", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup("mini_indentscope_disable"),
    callback = function()
        for _, filetype in ipairs(require("config").indent_exlude_ft) do
            if filetype == vim.bo.ft then
                vim.b.miniindentscope_disable = true
            end
        end
    end,
})
