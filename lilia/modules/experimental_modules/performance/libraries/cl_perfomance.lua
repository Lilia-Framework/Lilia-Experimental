--------------------------------------------------------------------------------------------------------------------------
function MODULE:ClientInitializedModules()
    for _, timerName in pairs(lia.config.ClientTimersToRemove) do
        timer.Remove(timerName)
    end

    for k, v in pairs(lia.config.ClientStartupConsoleCommand) do
        RunConsoleCommand(k, v)
    end
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PostGamemodeLoaded()
    scripted_ents.GetStored("base_gmodentity").t.Think = nil
end
--------------------------------------------------------------------------------------------------------------------------