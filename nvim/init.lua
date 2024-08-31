local require = require
local pcall = pcall

require("options")
require("keymaps")
require("autocmds")

do
    local vim = vim
    local os = os
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "--branch=stable",
            lazyrepo,
            lazypath,
        })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out, "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end

    vim.opt.rtp:prepend(lazypath)
end

require("plugins")

pcall(vim.cmd.colorscheme, "carbonfox")
-- pcall(vim.cmd.colorscheme, "gruvbox")
-- pcall(vim.cmd.colorscheme, "tokyonight-night")

vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { link = "TSRainbowRed" })
vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#fccd27" })
vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#ff832b" })
vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { link = "TSRainbowViolet" })
vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { link = "TSRainbowCyan" })
vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { link = "TSRainbowGreen" })
vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { link = "TSRainbowBlue" })

vim.api.nvim_set_hl(0, "DashboardKey",  { fg = "#3DDBD9" })
vim.api.nvim_set_hl(0, "DashboardDesc", { fg = "#33B1FF" })
vim.api.nvim_set_hl(0, "DashboardIcon", { fg = "#EE5396" })
