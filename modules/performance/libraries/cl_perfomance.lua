----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ClientInitializedModules()
    for _, timerName in pairs(lia.config.ClientTimersToRemove) do
        timer.Remove(timerName)
    end

    for k, v in pairs(lia.config.ClientStartupConsoleCommand) do
        RunConsoleCommand(k, v)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PostGamemodeLoaded()
    scripted_ents.GetStored("base_gmodentity").t.Think = nil
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not lia.config.NumpadActive then
    numpad.Activate = function() end
    numpad.Deactivate = function() end
    numpad.Toggle = function() end
    numpad.OnDown = function() end
    numpad.OnUp = function() end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------