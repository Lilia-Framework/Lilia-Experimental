﻿----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    sam.config.set("Restrictions.Tool", false)
    sam.config.set("Restrictions.Limits", false)
    sam.config.set("Restrictions.Spawning", false)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(client)
    local StaffRank = lia.config.DefaultStaff[client:SteamID()]
    if StaffRank then
        RunConsoleCommand("sam", "setrank", client:SteamID(), StaffRank)
        client:ChatPrint("You have been set as rank: " .. StaffRank)
        print(client:Nick() .. " has been set as rank: " .. StaffRank)
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------