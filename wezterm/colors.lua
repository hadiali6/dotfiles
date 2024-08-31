local M = {}
M.set_colors = function(config, colors)
    config.colors = {
        foreground = colors.fg,
        background = colors.bg,
        cursor_bg = colors.fg,
        cursor_fg = colors.bg,
        cursor_border = colors.bg,
        selection_bg = colors.bright.black,
        selection_fg = colors.fg,
        ansi = {
            colors.bright.black,
            colors.bright.red,
            colors.bright.green,
            colors.bright.yellow,
            colors.bright.blue,
            colors.bright.magenta,
            colors.bright.cyan,
            colors.bright.white,
        },
        brights = {
            colors.regular.black,
            colors.regular.red,
            colors.regular.green,
            colors.regular.yellow,
            colors.regular.blue,
            colors.regular.magenta,
            colors.regular.cyan,
            colors.regular.white,
        },
        tab_bar = {
            background = "#090909",
            active_tab = {
                bg_color = colors.bg,
                fg_color = colors.fg,
            },
            inactive_tab = {
                bg_color = "#292929",
                fg_color = "#6f6f6f",
            },
            new_tab = {
                bg_color = "#333333",
                fg_color = "#6f6f6f",
            },
        },
    }

end

return M
