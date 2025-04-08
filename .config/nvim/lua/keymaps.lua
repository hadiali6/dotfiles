vim.keymap.set({ "n" }, "<leader>tw", function()
    vim.opt.wrap = not vim.opt.wrap._value
    vim.opt.linebreak = not vim.opt.linebreak._value
    if vim.opt.linebreak._value == true then
        vim.opt.colorcolumn = "0"
    else
        vim.opt.colorcolumn = "100"
    end
end)

vim.keymap.set("n", "<leader>tr", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
end, { desc = "Toggle Relative Line Numbes" })

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>od", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set({ "n", "x", "t" }, "<leader><Tab>", "<C-^>")
