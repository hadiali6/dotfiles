local vim = vim
local require = require

---@alias plugin_key { key: string, cmd: string|function, desc: string? }

---@param mapping string
---@param func string | function
---@param desc string
---@return plugin_key
local function map(mapping, func, desc)
    return { mapping, func, desc }
end

local toggler = false

return {
    "mfussenegger/nvim-lint",

    ---@type plugin_key[]
    keys = {
        map("<leader>lb", function()
            local lint = require("lint")
            lint.linters_by_ft = {
                lua = { "selene" },
            }
            local ns = lint.get_namespace(lint.linters_by_ft[vim.bo.ft][1])
            if toggler == true then
                vim.diagnostic.reset(ns, vim.api.nvim_get_current_buf())
                toggler = false
            else
                lint.try_lint()
                toggler = true
            end
        end, "Lint Buffer"),
    },
}
