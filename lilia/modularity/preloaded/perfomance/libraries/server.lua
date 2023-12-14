﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ServersideInitializedModules()
    for _, timerName in pairs(self.ServerTimersToRemove) do
        if timer.Exists(timerName) then timer.Remove(timerName) end
    end

    for k, v in pairs(self.ServerStartupConsoleCommand) do
        if concommand.GetTable()[k] then RunConsoleCommand(k, v) end
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
