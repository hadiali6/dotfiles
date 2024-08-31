local require = require
return {
    require(... .. ".theme"),
    require(... .. ".rainbow"),
    require(... .. ".colorizer"),
    require(... .. ".statusline"),
    require(... .. ".indent"),
    require(... .. ".dashboard"),
}
