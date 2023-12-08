------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CanProperty(client, property, entity)
    if entity:GetCreator() == client and (property == "remover" or property == "collision") then return true end
    if CAMI.PlayerHasAccess(client, "Staff Permissions - Access Tool " .. property:gsub("^%l", string.upper), nil) or client:isStaffOnDuty() then
        if entity:IsWorld() and IsValid(entity) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Can Property World Entities", nil) end
        if table.HasValue(RestrictionCore.RemoverBlockedEntities, entity:GetClass()) or table.HasValue(RestrictionCore.PhysGunMoveRestrictedEntityList, entity:GetClass()) then return CAMI.PlayerHasAccess(client, "Staff Permissions - Use Entity Properties on Blocked Entities", nil) end

        return true
    end

    return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------