﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:BackDoorApplyPunishment(client)
    ServerLog("Attempted backdoor by " .. client:SteamID() .. ". He was bannned.")
    client:Kick("Banned for cheating.")
    client:Ban(0, "You have easily detectable hacks and should be ashamed. Banned for cheating.")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
