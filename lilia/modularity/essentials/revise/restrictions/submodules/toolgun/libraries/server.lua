------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:CanTool(client, _, tool)
    local privilege = "Staff Permissions - Access Tool " .. tool:gsub("^%l", string.upper)
    local entity = client:GetTracedEntity()
    if IsValid(client) and client:getChar():hasFlags("t") or CAMI.PlayerHasAccess(client, privilege, nil) or client:isStaffOnDuty() then
        if IsValid(entity) and entity:GetCreator() == client and entity:GetClass() == "prop_physics" then return true end
        if tool == "advdupe2" and (table.HasValue(RestrictionCore.DuplicatorBlackList, entity) and IsValid(entity)) then return false end
        if tool == "permaprops" and string.StartWith(entity:GetClass(), "lia_") and IsValid(entity) then return false end
        if tool == "material" and IsValid(entity) and entity:GetClass() == "prop_vehicle_jeep" then return false end
        if tool == "weld" and IsValid(entity) and entity:GetClass() == "sent_ball" then return false end
        if tool == "remover" then
            if table.HasValue(RestrictionCore.RemoverBlockedEntities, entity:GetClass()) and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove Blocked Entities", nil) end
            if entity:IsWorld() and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Remove World Entities", nil) end
        end
        return true
    end
    return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
