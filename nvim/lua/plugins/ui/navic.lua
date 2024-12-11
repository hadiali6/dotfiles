---@param callback_on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
local function on_attach(callback_on_attach, name)
    return vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf ---@type number
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and (not name or client.name == name) then
                return callback_on_attach(client, buffer)
            end
        end,
    })
end

return {
    "SmiteshP/nvim-navic",
    init = function()
        vim.cmd("highlight! link NavicText @diff.plus")
        vim.g.navic_silence = true
        on_attach(function(client, buffer)
            if client.supports_method("textDocument/documentSymbol") then
                require("nvim-navic").attach(client, buffer)
            end
        end)
    end,
    opts = {
        separator = " > ",
        highlight = true,
        depth_limit = 10,
        depth_limit_indicator = "..",
        lazy_update_context = true,
        icons = {
            File = "",
            Module = "",
            Namespace = "",
            Package = "",
            Class = "",
            Method = "",
            Property = "",
            Field = "",
            Constructor = "",
            Enum = "",
            Interface = "",
            Function = "",
            Variable = "",
            Constant = "",
            String = "",
            Number = "",
            Boolean = "",
            Array = "",
            Object = "",
            Key = "",
            Null = "",
            EnumMember = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = "",
        },
        format_text = function(text)
            return text
        end,
    },
}
