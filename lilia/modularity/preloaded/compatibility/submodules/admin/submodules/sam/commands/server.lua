
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for _, commandInfo in ipairs(sam.command.get_commands()) do
    local customSyntax = ""
    for _, argInfo in ipairs(commandInfo.args) do
        customSyntax = customSyntax == "" and "[" or customSyntax .. " ["
        customSyntax = customSyntax .. (argInfo.default and tostring(type(argInfo.default)) or "string") .. " "
        customSyntax = customSyntax .. argInfo.name .. "]"
    end

    lia.command.add(
        commandInfo.name,
        {
            privilege = commandInfo.name,
            adminOnly = commandInfo.default_rank == "admin",
            superAdminOnly = commandInfo.default_rank == "superadmin",
            syntax = customSyntax,
            onRun = function(arguments) RunConsoleCommand("sam", commandInfo.name, unpack(arguments)) end
        }
    )
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
