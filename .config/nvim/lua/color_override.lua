local hl = vim.api.nvim_set_hl
if vim.g.colors_name == "carbonfox" then
    hl(0, "RainbowDelimiterRed", { link = "TSRainbowRed" })
    hl(0, "RainbowDelimiterYellow", { fg = "#fccd27" })
    hl(0, "RainbowDelimiterOrange", { fg = "#ff832b" })
    hl(0, "RainbowDelimiterViolet", { link = "TSRainbowViolet" })
    hl(0, "RainbowDelimiterCyan", { link = "TSRainbowCyan" })
    hl(0, "RainbowDelimiterGreen", { link = "TSRainbowGreen" })
    hl(0, "RainbowDelimiterBlue", { link = "TSRainbowBlue" })

    hl(0, "NavicIconsFile", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsModule", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsNamespace", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsPackage", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsClass", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsMethod", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsProperty", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsField", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsConstructor", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsEnum", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsInterface", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsFunction", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsVariable", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsConstant", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsString", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsNumber", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsBoolean", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsArray", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsObject", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsKey", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsNull", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsEnumMember", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsStruct", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsEvent", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsOperator", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicIconsTypeParameter", { bg = "#0c0c0c", fg = "#ffffff" })
    hl(0, "NavicText", { bg = "#0c0c0c", fg = "#b6b8bb" })
    hl(0, "NavicSeparator", { bg = "#0c0c0c", fg = "#ff832b" })
    hl(0, "Function", { fg = "#99daff" })
    hl(0, "@keyword.modifier.zig", { fg = "#d4bbff" })
    hl(0, "@lsp.type.keywordLiteral.zig", { fg = "#ff7eb6" })
end
