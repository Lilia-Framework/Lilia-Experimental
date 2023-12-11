﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GM = GM or GAMEMODE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CanTool(client, _, tool)
    local privilege = "Staff Permissions - Access Tool " .. tool:gsub("^%l", string.upper)
    local entity = client:GetTracedEntity()
    local validEntity = IsValid(entity)
    if IsValid(client) and (client:getChar():hasFlags("t") or client:isStaffOnDuty()) and CAMI.PlayerHasAccess(client, privilege, nil) then
        if tool == "material" and validEntity and (entity:GetClass() == "prop_vehicle_jeep" or string.lower(toolobj:GetClientInfo("override")) == "pp/copy") then return false end
        if tool == "permaprops" and string.StartWith(entity:GetClass(), "lia_") and validEntity then return false end
        if tool == "weld" and validEntity and entity:GetClass() == "sent_ball" then return false end
        if tool == "duplicator" then
            if table.HasValue(RestrictionCore.DuplicatorBlackList, entity) and validEntity then return false end
            if client.CurrentDupe and client.CurrentDupe.Entities then
                for _, v in pairs(client.CurrentDupe.Entities) do
                    if not v.ModelScale then return false end
                    if v.ModelScale > 10 then
                        client:notify("A model within this duplication exceeds the size limit!")
                        print("[Server Warning] Potential server crash using dupes attempt by player: " .. client:Nick() .. " (" .. client:SteamID() .. ")")

                        return false
                    end

                    v.ModelScale = 1
                end
            end
        end

        if tool == "remover" then
            if table.HasValue(RestrictionCore.RemoverBlockedEntities, entity:GetClass()) and validEntity then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove Blocked Entities", nil) end
            if entity:IsWorld() and validEntity then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove World Entities", nil) end
        end

        if tool == "button" and not table.HasValue(RestrictionCore.ButtonList, client:GetInfo("button_model")) then
            client:ConCommand("button_model models/maxofs2d/button_05.mdl")
            client:ConCommand("button_model")

            return false
        end

        return true
    end

    return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------