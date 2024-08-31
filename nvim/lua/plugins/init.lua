local require = require

require("lazy").setup({
    require(... .. ".ui"),
    require(... .. ".lsp"),
    require(... .. ".cmp"),
    require(... .. ".format"),
    require(... .. ".lint"),
    require(... .. ".treesitter"),
    require(... .. ".git"),
    require(... .. ".misc"),
})
