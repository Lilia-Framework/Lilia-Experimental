----------------------------------------------------------------------------------------------
lia.command.add(
    "banooc",
    {
        privilege = "Ban OOC",
        syntax = "<string target>",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "unbanooc",
    {
        privilege = "Unban OOC",
        syntax = "<string target>",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "blockooc",
    {
        privilege = "Block OOC",
        syntax = "<string target>",
        onRun = function(client, arguments) end
    }
)

----------------------------------------------------------------------------------------------
lia.command.add(
    "clearchat",
    {
        superAdminOnly = true,
        privilege = "Clear Chat",
        onRun = function(client, arguments) end
    }
)
----------------------------------------------------------------------------------------------