vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/NMAC427/guess-indent.nvim" },
    { src = "https://github.com/altermo/ultimate-autopair.nvim" },
    { src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("4.x") },
    { src = "https://github.com/willothy/flatten.nvim" },
    { src = "https://github.com/echasnovski/mini.move" },
    { src = "https://github.com/echasnovski/mini.splitjoin" },
    { src = "https://github.com/echasnovski/mini.ai" },
    { src = "https://github.com/echasnovski/mini.align" },
})

require("guess-indent").setup({})
require("ultimate-autopair").setup({})
require("nvim-surround").setup({})
require("flatten").setup({})

require("mini.move").setup({
    mappings = {
        left = "<M-H>",
        down = "<M-J>",
        up = "<M-K>",
        right = "<M-L>",

        line_left = "<M-H>",
        line_down = "<M-J>",
        line_up = "<M-K>",
        line_right = "<M-L>",
    },
    options = {
        reindent_linewise = true,
    },
})
require("mini.splitjoin").setup({
    mappings = {
        toggle = "gS",
        split = "",
        join = "",
    },
    detect = {
        brackets = nil,
        separator = ",",
        exclude_regions = nil,
    },
    split = {
        hooks_pre = {},
        hooks_post = {},
    },
    join = {
        hooks_pre = {},
        hooks_post = {},
    },
})
require("mini.ai").setup({
    mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "g[",
        goto_right = "g]",
    },
    n_lines = 500,
    search_method = "cover_or_next",
    silent = false,
})

require("mini.align").setup({
    mappings = {
        start = "ga",
        start_with_preview = "gA",
    },
    options = {
        split_pattern = "",
        justify_side = "left",
        merge_delimiter = "",
    },
    steps = {
        pre_split = {},
        split = nil,
        pre_justify = {},
        justify = nil,
        pre_merge = {},
        merge = nil,
    },
    silent = false,
})
