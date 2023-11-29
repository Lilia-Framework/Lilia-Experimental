------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.util.includeDir("lilia/libraries/thirdparty", true, true)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local filesToInclude = {
    ["lilia/libraries/color.lua"] = "shared",
    ["lilia/libraries/currency.lua"] = "shared",
    ["lilia/libraries/bars.lua"] = "client",
    ["lilia/libraries/notice.lua"] = "client",
    ["lilia/libraries/menu.lua"] = "client",
    ["lilia/libraries/data/sh_data.lua"] = "shared",
    ["lilia/libraries/data/sv_data.lua"] = "server",
    ["lilia/libraries/util/sh_util.lua"] = "shared",
    ["lilia/libraries/util/cl_util.lua"] = "client",
    ["lilia/libraries/util/sv_util.lua"] = "server",
    ["lilia/libraries/blur3d2d/sh_blur3d2d.lua"] = "shared",
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
    ["lilia/libraries/animations/sh_animation.lua"] = "shared",
    ["lilia/libraries/flags/sh_flag.lua"] = "shared",
    ["lilia/libraries/flags/sv_flag.lua"] = "server",
    ["lilia/libraries/date/sh_date.lua"] = "shared",
    ["lilia/libraries/commands/sh_commands.lua"] = "shared",
    ["lilia/libraries/commands/sv_commands.lua"] = "server",
    ["lilia/libraries/commands/cl_commands.lua"] = "client",
    ["lilia/libraries/teams/sh_faction.lua"] = "shared",
    ["lilia/libraries/teams/cl_faction.lua"] = "client",
    ["lilia/libraries/teams/sh_class.lua"] = "shared",
    ["lilia/libraries/logger/sh_logger.lua"] = "shared",
    ["lilia/libraries/logger/cl_logger.lua"] = "shared",
    ["lilia/libraries/logger/sv_logger.lua"] = "server",
    ["lilia/libraries/character/sh_character.lua"] = "shared",
    ["lilia/libraries/character/sv_character.lua"] = "server",
    ["lilia/libraries/chatbox/sh_chatbox.lua"] = "shared",
    ["lilia/libraries/chatbox/sv_chatbox.lua"] = "server",
    ["lilia/libraries/scroll/sh_scroll.lua"] = "shared",
    ["lilia/libraries/scroll/sv_scroll.lua"] = "server",
    ["lilia/libraries/scroll/cl_scroll.lua"] = "client",
    ["lilia/libraries/hooks/sh_hooks.lua"] = "shared",
    ["lilia/libraries/hooks/sv_hooks.lua"] = "server",
    ["lilia/libraries/hooks/cl_hooks.lua"] = "client",
    ["lilia/libraries/hooks/sv_hooks.lua"] = "server",
    ["lilia/libraries/hooks/cl_hooks.lua"] = "client",
    ["lilia/libraries/netcalls/cl_netcalls.lua"] = "client",
    ["lilia/libraries/netcalls/sv_netcalls.lua"] = "server",
    ["lilia/libraries/objects/commands/cl_commands.lua"] = "client",
    ["lilia/libraries/objects/commands/sv_commands.lua"] = "server",
    ["lilia/libraries/moduleloader.lua"] = "shared",
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for fileName, state in pairs(filesToInclude) do
    lia.util.include(fileName, state)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.util.loadEntities("lilia/libraries/objects/entities")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.lang.loadFromDir("lilia/libraries/objects/languages")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.item.loadFromDir("lilia/libraries/objects/items", true)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.util.includeDir("lilia/libraries/derma", true, true)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------