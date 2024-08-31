local vim = vim
local ipairs = ipairs
local require = require
local math = math
local string = string
local tostring = tostring

local M = { "nvimdev/dashboard-nvim" }

M.lazy = false

M.opts = function()
    local logo = [[
    ]]

    logo = string.rep("\n", 6) .. logo .. "\n\n"

    local opts = {
        theme = "doom",
        hide = {
            statusline = false,
        },
        config = {
            header = vim.split(logo, "\n"),
            center = {
                {
                    action = "Telescope find_files",
                    desc = " Find File",
                    key = "f"
                },
                {
                    action = "ene | startinsert",
                    desc = " New File",
                    key = "n"
                },
                {
                    action = "Telescope oldfiles",
                    desc = " Recent Files",
                    key = "r"
                },
                {
                    action = "Telescope live_grep",
                    desc = " Find Text",
                    key = "g"
                },
                {
                    action = "lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath 'config' })",
                    desc = " Config",
                    key = "c"
                },
                -- { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
                {
                    action = "Lazy",
                    desc = " Lazy",
                    key = "l"
                },
                {
                    action = function()
                        vim.api.nvim_input("<cmd>qa<cr>")
                    end,
                    desc = " Quit",
                    key = "q",
                },
            },
            footer = function()
                local stats = require("lazy").stats()
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                return { " Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
        },
    }

    for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
    end

    if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(vim.api.nvim_get_current_win()),
            once = true,
            callback = function()
                vim.schedule(function()
                    vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
                end)
            end,
        })
    end

    return opts
end

return M
