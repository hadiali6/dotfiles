return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            icons_enabled = false,
            theme = "auto",
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 50,
                tabline = 100,
                winbar = 100,
            },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                "diff",
                "diagnostics",
            },
            lualine_c = {
                "filename",
                {
                    function()
                        local navic_ok, navic = pcall(require, "nvim-navic")
                        if navic_ok then
                            return navic.get_location()
                        end
                    end,
                    function()
                        local navic_ok, navic = pcall(require, "nvim-navic")
                        if navic_ok then
                            return navic.is_available()
                        end
                    end,
                },
            },
            lualine_x = {
                "filetype",
            },
            lualine_y = { "%l:%c" },
            lualine_z = { { "progress" }, { "%L" } },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}

-- return {
--     "bluz71/nvim-linefly",
--     config = function()
--         vim.g.linefly_options = {
--             separator_symbol = "⎪",
--             progress_symbol = "",
--             active_tab_symbol = "▪",
--             git_branch_symbol = "",
--             error_symbol = "E",
--             warning_symbol = "W",
--             information_symbol = "I",
--             ellipsis_symbol = "…",
--             tabline = false,
--             winbar = false,
--             with_file_icon = true,
--             with_git_branch = true,
--             with_git_status = true,
--             with_diagnostic_status = true,
--             with_session_status = true,
--             with_attached_clients = false,
--             with_lsp_status = false,
--             with_macro_status = false,
--             with_search_count = false,
--             with_spell_status = false,
--             with_indent_status = false,
--         }
--     end,
-- }
