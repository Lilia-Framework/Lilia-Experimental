﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ServersideInitializedModules()
    for _, timerName in pairs(lia.config.ServerTimersToRemove) do
        if timer.Exists(timerName) then
            timer.Remove(timerName)
        end
    end

    for k, v in pairs(lia.config.ServerStartupConsoleCommand) do
        if concommand.GetTable()[k] then
            RunConsoleCommand(k, v)
        end
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------