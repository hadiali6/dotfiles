return {
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    {
        "willothy/flatten.nvim",
        event = "TermOpen",
        config = true,
        lazy = false,
        priority = 1001,
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
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
    {
        "dzfrias/arena.nvim",
        keys = {
            {
                "<leader><leader>",
                function()
                    require("arena").toggle()
                end,
                desc = "Select Session",
            },
        },
        event = "BufWinEnter",
        -- Calls `.setup()` automatically
        config = true,
        opts = {
            -- Maxiumum number of files that the arena window can contain, or `nil` for
            -- an unlimited amount
            max_items = 5,
            -- Always show the enclosing directory for these paths
            always_context = { "mod.rs", "init.lua" },
            -- When set, ignores the current buffer when listing files in the window.
            ignore_current = false,
            -- Options to apply to the arena buffer.
            buf_opts = {
                ["relativenumber"] = false,
            },
            -- Filter out buffers per the project they belong to.
            per_project = false,
            --- Add devicons (from nvim-web-devicons, if installed) to buffers
            devicons = false,

            window = {
                width = 60,
                height = 10,
                border = "rounded",

                -- Options to apply to the arena window.
                opts = {},
            },

            -- Keybinds for the arena window.
            keybinds = {
                -- ["e"] = function()
                --   vim.cmd("echo \"Hello from the arena!\"")
                -- end
            },

            -- Change the way the arena listing looks with custom rendering functions
            renderers = {},

            -- Config for frecency algorithm.
            algorithm = {
                -- Multiplies the recency by a factor. Must be greater than zero.
                -- A smaller number will mean less of an emphasis on recency!
                recency_factor = 0.5,
                -- Same as `recency_factor`, but for frequency!
                frequency_factor = 1,
            },
        },
    },
}
