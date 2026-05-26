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

