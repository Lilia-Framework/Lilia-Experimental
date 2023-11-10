--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "freezeallprops",
    {
        superAdminOnly = true,
        privilege = "Freeze All Props",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "status",
    {
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "setclass",
    {
        privilege = "Set Class",
        adminOnly = true,
        syntax = "<string target> <string class>",
        onRun = function(client, arguments) end,
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "checkmoney",
    {
        syntax = "<string target>",
        privilege = "Check Money",
        adminOnly = true,
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "cleanitems",
    {
        superAdminOnly = true,
        privilege = "Clean Items",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "cleanprops",
    {
        superAdminOnly = true,
        privilege = "Clean Props",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "savemap",
    {
        superAdminOnly = true,
        privilege = "Save Map Data",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "cleannpcs",
    {
        superAdminOnly = true,
        privilege = "Clean NPCs",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flags",
    {
        adminOnly = true,
        syntax = "<string name>",
        privilege = "Check Flags",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "clearchat",
    {
        superAdminOnly = true,
        privilege = "Clear Chat",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "checkallmoney",
    {
        superAdminOnly = true,
        syntax = "<string charname>",
        privilege = "Check All Money",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "return",
    {
        adminOnly = true,
        privilege = "Return",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "findallflags",
    {
        adminOnly = false,
        privilege = "Find All Flags",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "chargiveitem",
    {
        superAdminOnly = true,
        syntax = "<string name> <string item>",
        privilege = "Give Item",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "netmessagelogs",
    {
        superAdminOnly = true,
        privilege = "Check Net Message Log",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "returnitems",
    {
        superAdminOnly = true,
        syntax = "<string name>",
        privilege = "Return Items",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "announce",
    {
        superAdminOnly = true,
        syntax = "<string factions> <string text>",
        privilege = "Make Announcements",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "voiceunban",
    {
        adminOnly = true,
        privilege = "Voice Unban Character",
        syntax = "<string name>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "voiceban",
    {
        adminOnly = true,
        privilege = "Voice ban Character",
        syntax = "<string name>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flip",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "liststaff",
    {
        adminOnly = false,
        privilege = "List Staff",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "listvip",
    {
        adminOnly = false,
        privilege = "List VIPs",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "listusers",
    {
        adminOnly = false,
        privilege = "List Users",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "rolld",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "<number dice> <number pips> <number bonus>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "roll",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "chardesc",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "<string desc>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "beclass",
    {
        adminOnly = false,
        syntax = "<string class>",
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "chargetup",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "givemoney",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "<number amount>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "bringlostitems",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "carddraw",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "fallover",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "[number time]",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "factionlist",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "<string text>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "getpos",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "doorname",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

if lia.config.AdvertisementEnabled then
    lia.command.add(
        "advertisement",
        {
            adminOnly = false,
            privilege = "Default User Commands",
            syntax = "<string factions> <string text>",
            onRun = function(client, arguments) end
        }
    )
end

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetspeed",
    {
        privilege = "Set Character Speed",
        adminOnly = true,
        syntax = "<string name> <number speed>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetjump",
    {
        adminOnly = true,
        privilege = "Set Character Jump",
        syntax = "<string name> <number power>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charaddmoney",
    {
        privilege = "Add Money",
        superAdminOnly = true,
        syntax = "<string target> <number amount>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charban",
    {
        superAdminOnly = true,
        syntax = "<string name>",
        privilege = "Ban Characters",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetdesc",
    {
        adminOnly = true,
        syntax = "<string name> <string desc>",
        privilege = "Change Description",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "plytransfer",
    {
        adminOnly = true,
        syntax = "<string name> <string faction>",
        privilege = "Transfer Player",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetname",
    {
        adminOnly = true,
        syntax = "<string name> [string newName]",
        privilege = "Change Name",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "chargetmodel",
    {
        adminOnly = true,
        syntax = "<string name>",
        privilege = "Retrieve Model",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetmodel",
    {
        adminOnly = true,
        syntax = "<string name> <string model>",
        privilege = "Change Model",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetbodygroup",
    {
        adminOnly = true,
        syntax = "<string name> <string bodyGroup> [number value]",
        privilege = "Change Bodygroups",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetskin",
    {
        adminOnly = true,
        syntax = "<string name> [number skin]",
        privilege = "Change Skin",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "chargetmoney",
    {
        adminOnly = true,
        syntax = "<string name>",
        privilege = "Retrieve Money",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetmoney",
    {
        superAdminOnly = true,
        syntax = "<string target> <number amount>",
        privilege = "Change Money",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetattrib",
    {
        superAdminOnly = true,
        syntax = "<string charname> <string attribname> <number level>",
        privilege = "Change Attributes",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charaddattrib",
    {
        superAdminOnly = true,
        syntax = "<string charname> <string attribname> <number level>",
        privilege = "Change Attributes",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "clearinv",
    {
        superAdminOnly = true,
        syntax = "<string name>",
        privilege = "Clear Inventory",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flaggive",
    {
        adminOnly = true,
        syntax = "<string name> [string flags]",
        privilege = "Toggle Flags",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flagtake",
    {
        adminOnly = true,
        syntax = "<string name> [string flags]",
        privilege = "Toggle Flags",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charkick",
    {
        adminOnly = true,
        syntax = "<string name>",
        privilege = "Kick Characters",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "plywhitelist",
    {
        adminOnly = true,
        privilege = "Whitelist Characters",
        syntax = "<string name> <string faction>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "plyunwhitelist",
    {
        adminOnly = true,
        privilege = "Un-Whitelist Characters",
        syntax = "<string name> <string faction>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charunban",
    {
        syntax = "<string name>",
        superAdminOnly = true,
        privilege = "Un-Ban Characters",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "viewextdescription",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetextdescription",
    {
        adminOnly = true,
        privilege = "Change Description",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flagpet",
    {
        privilege = "Give pet Flags",
        adminOnly = true,
        syntax = "[character name]",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flags",
    {
        privilege = "Check Flags",
        adminOnly = true,
        syntax = "<string name>",
        onRun = function(client, arguments) end
    }
)

--------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "flagragdoll",
    {
        adminOnly = true,
        privilege = "Hand Ragdoll Medals",
        syntax = "<string name>",
        onRun = function(client, arguments) end
    }
)
--------------------------------------------------------------------------------------------------------------------------
