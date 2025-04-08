local dashboard = {
    preset = {
        header = string.rep("\n", 1),
        keys = {
            { key = "s", desc = "restore session", action = ':lua require("persistence").load()' },
            { key = "f", desc = "find file",       action = ':lua Snacks.dashboard.pick("files")' },
            { key = "n", desc = "new file",        action = ":ene | startinsert" },
            { key = "g", desc = "find text",       action = ':lua Snacks.dashboard.pick("live_grep")' },
            { key = "r", desc = "recent files",    action = ':lua Snacks.dashboard.pick("oldfiles")' },
            { key = "c", desc = "config",          action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})' },
            { key = "l", desc = "lazy",            action = ":Lazy" },
            { key = "q", desc = "quit",            action = ":qa" },
        },
    },
}

return {
    "folke/snacks.nvim",
    opts = {
        bigfile = {},
        indent = {
            priority = 2,
            animate = { enabled = false },
            scope = { enabled = false },
        },
        statuscolumn = {},
        words = {},

        dashboard = dashboard,
    },
}
