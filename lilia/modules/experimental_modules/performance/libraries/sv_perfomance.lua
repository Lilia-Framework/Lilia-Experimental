--------------------------------------------------------------------------------------------------------------------------
local vjThink = 0
--------------------------------------------------------------------------------------------------------------------------
function GM:ServersideInitializedModules()
    for _, timerName in pairs(lia.config.ServerTimersToRemove) do
        timer.Remove(timerName)
    end

    for k, v in pairs(lia.config.ServerStartupConsoleCommand) do
        RunConsoleCommand(k, v)
    end

    for k, v in pairs(ents.GetAll()) do
        if lia.config.EntitiesToBeRemoved[v:GetClass()] then v:Remove() end
    end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:Think()
    if not VJ then return end
    if vjThink <= CurTime() then
        for k, v in pairs(lia.config.VJBaseConsoleCommands) do
            RunConsoleCommand(k, v)
        end

        vjThink = CurTime() + 180
    end
end
--------------------------------------------------------------------------------------------------------------------------