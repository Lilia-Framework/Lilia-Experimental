﻿----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsell",
    {
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorbuy",
    {
        privilege = "Default User Commands",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetunownable",
    {
        adminOnly = true,
        syntax = "[string name]",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetownable",
    {
        adminOnly = true,
        syntax = "[string name]",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "dooraddfaction",
    {
        adminOnly = true,
        syntax = "[string faction]",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorremovefaction",
    {
        adminOnly = true,
        syntax = "[string faction]",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetdisabled",
    {
        adminOnly = true,
        syntax = "<bool disabled>",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsettitle",
    {
        syntax = "<string title>",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetparent",
    {
        adminOnly = true,
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetchild",
    {
        adminOnly = true,
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorremovechild",
    {
        adminOnly = true,
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsethidden",
    {
        adminOnly = true,
        syntax = "<bool hidden>",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "doorsetclass",
    {
        adminOnly = true,
        syntax = "[string faction]",
        privilege = "Manage Doors",
        onRun = function(client, arguments) end,
        alias = {"jobdoor"}
    }
)
----------------------------------------------------------------------------------------------
