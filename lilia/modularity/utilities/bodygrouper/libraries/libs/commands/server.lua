------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "viewBodygroups",
    {
        adminOnly = true,
        privilege = "Change Bodygroups",
        syntax = "[string name]",
        onRun = function(client, arguments)
            local target = lia.command.findPlayer(client, arguments[1] or "")
            net.Start("BodygrouperMenu")
            if IsValid(target) then net.WriteEntity(target) end
            net.Send(client)
        end
    }
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------