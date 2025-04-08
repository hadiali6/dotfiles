return {
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            cmap = false,
        },
        init = function()
            vim.keymap.set({ "n", "i" }, "<C-p>", require("ultimate-autopair").toggle, { desc = "Toggle AutoPair" })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    {
        "willothy/flatten.nvim",
        event = "TermOpen",
        config = true,
        lazy = false,
        priority = 1001,
    },
    {
        "echasnovski/mini.move",
        opts = {
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
        },
    },
    {
        "echasnovski/mini.splitjoin",
        opts = {
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
        },
    },
    {
        "echasnovski/mini.ai",
        opts = {
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
        },
    },
    {
        "echasnovski/mini.align",
        opts = {
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
        },
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>qS",
                function()
                    require("persistence").select()
                end,
                desc = "Select Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
}
