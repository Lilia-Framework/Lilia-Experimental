--------------------------------------------------------------------------------------------------------------------------
lia.util.includeDir("lilia/libraries/thirdparty", true, true)
--------------------------------------------------------------------------------------------------------------------------
local filesToInclude = {
    ["lilia/libraries/color.lua"] = "shared",
    ["lilia/libraries/currency.lua"] = "shared",
    ["lilia/libraries/fonts.lua"] = "client",
    ["lilia/libraries/notice.lua"] = "client",
    ["lilia/libraries/menu.lua"] = "client",
    ["lilia/libraries/data/sh_data.lua"] = "shared",
    ["lilia/libraries/data/sv_data.lua"] = "server",
    ["lilia/libraries/util/sh_util.lua"] = "shared",
    ["lilia/libraries/util/cl_util.lua"] = "client",
    ["lilia/libraries/util/sv_util.lua"] = "server",
    ["lilia/libraries/netloggers/cl_netmessagelogger.lua"] = "client",
    ["lilia/libraries/netloggers/sv_netmessagelogger.lua"] = "server",
    ["lilia/libraries/netloggers/sv_netwatcher.lua"] = "server",
    ["lilia/libraries/networking/sh_networking.lua"] = "shared",
    ["lilia/libraries/networking/cl_networking.lua"] = "client",
    ["lilia/libraries/networking/sv_networking.lua"] = "server",
    ["lilia/libraries/items/sh_items.lua"] = "shared",
    ["lilia/libraries/items/sv_items.lua"] = "server",
    ["lilia/libraries/languages/sh_language.lua"] = "shared",
    ["lilia/libraries/languages/cl_language.lua"] = "client",
    ["lilia/libraries/languages/sv_language.lua"] = "server",
    ["lilia/libraries/moduleloader.lua"] = "shared",

}
--------------------------------------------------------------------------------------------------------------------------
for fileName, state in pairs(filesToInclude) do
    lia.util.include(fileName, state)
end
--------------------------------------------------------------------------------------------------------------------------