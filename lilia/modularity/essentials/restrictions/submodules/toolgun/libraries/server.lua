------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GM = GM or GAMEMODE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CanTool(client, _, tool)
    local privilege = "Staff Permissions - Access Tool " .. tool:gsub("^%l", string.upper)
    local toolobj = client:GetActiveWeapon():GetToolObject()
    local entity = client:GetTracedEntity()
    if IsValid(client) and client:getChar():hasFlags("t") or CAMI.PlayerHasAccess(client, privilege, nil) or client:isStaffOnDuty() then
        if IsValid(entity) and entity:GetCreator() == client and entity:GetClass() == "prop_physics" then return true end
        if tool == "advdupe2" and (table.HasValue(RestrictionCore.DuplicatorBlackList, entity) and IsValid(entity)) then return false end
        if tool == "material" and IsValid(entity) and (entity:GetClass() == "prop_vehicle_jeep" or string.lower(toolobj:GetClientInfo("override")) == "pp/copy") then return false end
        if tool == "permaprops" and string.StartWith(entity:GetClass(), "lia_") and IsValid(entity) then return false end
        if tool == "weld" and IsValid(entity) and entity:GetClass() == "sent_ball" then return false end
        if tool == "remover" then
            if table.HasValue(RestrictionCore.RemoverBlockedEntities, entity:GetClass()) and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove Blocked Entities", nil) end
            if entity:IsWorld() and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove World Entities", nil) end
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