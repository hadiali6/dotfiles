local dashboard = {
    preset = {
        header = string.rep("\n", 2),
        keys = {
            { key = "s", desc = "restore session", action = ':lua require("persistence").load()' },
            { key = "f", desc = "find file", action = ':lua Snacks.dashboard.pick("files")' },
            { key = "n", desc = "new file", action = ":ene | startinsert" },
            { key = "g", desc = "find text", action = ':lua Snacks.dashboard.pick("live_grep")' },
            { key = "r", desc = "recent files", action = ':lua Snacks.dashboard.pick("oldfiles")' },
            { key = "c", desc = "config", action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})' },
            { key = "l", desc = "lazy", action = ":Lazy" },
            { key = "q", desc = "quit", action = ":qa" },
        },
    },
}

return {
    "folke/snacks.nvim",

    opts = {
        bigfile = { enabled = true },

        terminal = {
            bo = {
                filetype = "snacks_terminal",
            },
            wo = {},
            keys = {
                q = "hide",
                gf = function(self)
                    local f = vim.fn.findfile(vim.fn.expand("<cfile>"), "**")
                    if f == "" then
                        Snacks.notify.warn("No file under cursor")
                    else
                        self:hide()
                        vim.schedule(function()
                            vim.cmd("e " .. f)
                        end)
                    end
                end,
                term_normal = {
                    "<esc>",
                    function(self)
                        self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                        if self.esc_timer:is_active() then
                            self.esc_timer:stop()
                            vim.cmd("stopinsert")
                        else
                            self.esc_timer:start(200, 0, function() end)
                            return "<esc>"
                        end
                    end,
                    mode = "t",
                    expr = true,
                    desc = "Double escape to normal mode",
                },
            },
        },

        indent = {
            indent = {
                enabled = true,
            },
            scope = {
                enabled = false,
                animate = {
                    enabled = false,
                },
            },
            filter = function(buf)
                local curr_ft = vim.bo[buf].ft
                for _, ft in ipairs(require("config").indent_exlude_ft) do
                    if curr_ft == ft then
                        return false
                    end
                end
                return true
            end,
        },
        statuscolumn = { enabled = true },
        words = {
            enabled = true, -- enable/disable the plugin
            debounce = 250, -- time in ms to wait before updating
            notify_jump = false, -- show a notification when jumping
            notify_end = true, -- show a notification when reaching the end
            foldopen = true, -- open folds after jumping
            jumplist = true, -- set jump point before jumping
            modes = { "n", "i", "c" }, -- modes to show references
        },
        dashboard = dashboard,
    },
}
