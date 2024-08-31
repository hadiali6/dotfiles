local table = table
local M = {}

table.insert(M, {
    "folke/tokyonight.nvim",
    lazy = true,
})

table.insert(M, {
    "EdenEast/nightfox.nvim",
    lazy = true,
})

table.insert(M, {
    "sainnhe/gruvbox-material",
    lazy = true,
})

table.insert(M, {
    dependencies = { "rktjmp/lush.nvim" },
    "rockyzhang24/arctic.nvim",
    lazy = true,
})

table.insert(M, {
    "Shatur/neovim-ayu",
    lazy = true,
})

table.insert(M, {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
})

return M
