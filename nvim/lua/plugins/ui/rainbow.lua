local vim = vim
local require = require

local M = { "https://gitlab.com/HiPhish/rainbow-delimiters.nvim" }

M.config = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    vim.g.rainbow_delimiters = {
        strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"],
        },
        query = {
            [""] = "rainbow-delimiters",
            -- lua = "rainbow-blocks",
        },
        priority = {
            [""] = 110,
            lua = 210,
        },
        highlight = {
            "RainbowDelimiterYellow",
            "RainbowDelimiterCyan",
            "RainbowDelimiterOrange",
            "RainbowDelimiterRed",
            "RainbowDelimiterBlue",
            "RainbowDelimiterViolet",
            "RainbowDelimiterGreen",
        },
    }
    vim.keymap.set("n", "<leader>rr", function()
        rainbow_delimiters.toggle(vim.api.nvim_get_current_buf())
    end)
end

return M
