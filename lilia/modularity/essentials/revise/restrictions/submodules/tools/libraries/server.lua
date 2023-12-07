------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CanTool(client, _, tool)
    local privilege = "Lilia - Staff Permissions - Access Tool " .. tool:gsub("^%l", string.upper)
    local entity = client:GetTracedEntity()
    if IsValid(client) and client:getChar():hasFlags("t") or CAMI.PlayerHasAccess(client, privilege, nil) or client:isStaffOnDuty() then
        if IsValid(entity) and entity:GetCreator() == client and entity:GetClass() == "prop_physics" then return true end
        if tool == "advdupe2" and (table.HasValue(lia.config.DuplicatorBlackList, entity) and IsValid(entity)) then return false end
        if tool == "permaprops" and string.StartWith(entity:GetClass(), "lia_") and IsValid(entity) then return false end
        if tool == "material" and IsValid(entity) and entity:GetClass() == "prop_vehicle_jeep" then return false end
        if tool == "weld" and IsValid(entity) and entity:GetClass() == "sent_ball" then return false end
        if tool == "remover" then
            if table.HasValue(lia.config.RemoverBlockedEntities, entity:GetClass()) and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Can Remove Blocked Entities", nil) end
            if entity:IsWorld() and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Can Remove World Entities", nil) end
        end

        return true
    end

    return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PhysgunPickup(client, entity)
    if IsValid(client) and entity:GetCreator() == client and entity:GetClass() == "prop_physics" then return true end
    if IsValid(client) and CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup", nil) or client:isStaffOnDuty() then
        if table.HasValue(lia.config.PhysGunMoveRestrictedEntityList, entity:GetClass()) then
            return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup on Restricted Entities", nil)
        elseif entity:IsVehicle() then
            return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup on Vehicles", nil)
        elseif entity:IsPlayer() then
            return CAMI.PlayerHasAccess(entity, "Lilia - Staff Permissions - Can't be Grabbed with PhysGun", nil) and CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Can Grab Players", nil)
        elseif entity:IsWorld() then
            return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Can Grab World Props", nil)
        end

        return true
    end

    return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------