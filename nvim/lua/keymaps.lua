local vim = vim

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>tr", function()
    vim.opt.relativenumber = not vim.opt.relativenumber._value
end, { desc = "Toggle Relative Line Numbes" })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous Diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next Diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Regex Search/Seplace" })

vim.keymap.set("x", "<leader>dP", '"_dP')
vim.keymap.set("x", "<leader>xP", '"_xP')
vim.keymap.set("x", "<leader>dp", '"_dp')
vim.keymap.set("x", "<leader>xp", '"_xp')
vim.keymap.set({ "x", "n" }, "<leader>xx", '"_x')
vim.keymap.set({ "x" }, "<leader>dd", '"_d')
vim.keymap.set({ "n" }, "<leader>dd", '"_dd')
