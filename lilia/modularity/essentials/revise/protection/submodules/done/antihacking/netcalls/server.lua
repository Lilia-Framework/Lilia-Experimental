﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
util.AddNetworkString("BanMeAmHack")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("BanMeAmHack", function(_, client) ProtectionCore:BackDoorApplyPunishment(client) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for k, v in pairs(MODULE.KnownExploits) do
    net.Receive(
        k,
        function(_, client)
            client.nextExploitNotify = client.nextExploitNotify or 0
            if client.nextExploitNotify > CurTime() then return end
            client.nextExploitNotify = CurTime() + 2
            for _, p in pairs(player.GetAll()) do
                if p:isStaff() then p:notify(client:Name() .. " (" .. client:SteamID() .. (v and ") may be attempting to crash the server!" or ") may be attempting to run exploits!")) end
            end
        end
    )
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
