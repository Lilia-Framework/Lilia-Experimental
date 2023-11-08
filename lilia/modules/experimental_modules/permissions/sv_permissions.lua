﻿--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnNPC(client)
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn NPCs", nil) or client:getChar():hasFlags("n") then return true end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnProp(client, model)
    local nextSpawnTime = client.NextSpawn or 0
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn Props", nil) or client:getChar():hasFlags("e") then
        if CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - No Spawn Delay") and (client.AdvDupe2 and client.AdvDupe2.Pasting) then return true end
        if not self:CheckSpawnPropBlackList(client, model) then return false end
        if nextSpawnTime < CurTime() then
            client.NextSpawn = CurTime() + 0.75
            return true
        else
            client:notify("You can't spawn props that fast!")
            return false
        end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnRagdoll(client)
    local nextSpawnTime = client.NextSpawn or 0
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn Ragdolls", nil) or client:getChar():hasFlags("r") then
        if CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - No Spawn Delay") and (client.AdvDupe2 and client.AdvDupe2.Pasting) then return true end
        if nextSpawnTime < CurTime() then
            client.NextSpawn = CurTime() + 0.75
            return true
        else
            client:notify("You can't spawn ragdolls that fast!")
            return false
        end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnSWEP(client)
    if client:getChar() and (CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn SWEPs", nil) or client:getChar():hasFlags("W")) then return true end
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerGiveSWEP(client)
    if client:getChar() and (CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn SWEPs", nil) or client:getChar():hasFlags("W")) then return true end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnEffect(client)
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn Effects", nil) or client:getChar():hasFlags("L") then return true end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnSENT(client)
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn SENTs", nil) or client:getChar():hasFlags("E") then return true end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnVehicle(client, model, name, data)
    if client:getChar() and client:getChar():hasFlags("C") or CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn Cars", nil) then
        if table.HasValue(lia.config.RestrictedVehicles, name) then
            if CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - Can Spawn Restricted Cars", nil) then
                return true
            else
                client:notify("You can't spawn this vehicle since it's restricted!")
            end
        else
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:CanTool(client, trace, tool)
    local privilege = "Lilia - Staff Permissions - Access Tool " .. tool:gsub("^%l", string.upper)
    local entity = client:GetTracedEntity()
    if client:getChar() and IsValid(entity) and (client:getChar():hasFlags("t") or CAMI.PlayerHasAccess(client, privilege, nil)) then
        if tool == "permaprops" and not string.StartWith(entity:GetClass(), "lia_") or (tool == "advdupe2" and not table.HasValue(lia.config.DuplicatorBlackList, entity:GetClass())) then return true end
        if tool == "remover" and table.HasValue(lia.config.RemoverBlockedEntities, entity:GetClass()) then return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Can Remove Blocked Entities", nil) end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:PhysgunPickup(client, entity)
    if client:getChar() then
        if entity:GetCreator() == client and entity:GetClass() == "prop_physics" then
            return true
        elseif CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup", nil) then
            if table.HasValue(lia.config.PhysGunMoveRestrictedEntityList, entity:GetClass()) then
                return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup on Restricted Entities", nil)
            elseif entity:IsVehicle() then
                return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Physgun Pickup on Vehicles", nil)
            else
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:CanProperty(client, property, entity)
    if client:getChar() and CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Access Tool " .. property:gsub("^%l", string.upper), nil) then
        if table.HasValue(lia.config.RemoverBlockedEntities, entity:GetClass()) or table.HasValue(lia.config.PhysGunMoveRestrictedEntityList, entity:GetClass()) then
            return CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - Use Entity Properties on Blocked Entities", nil)
        else
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:CheckSpawnPropBlackList(client, model)
    for _, gredwitch in pairs(file.Find("models/gredwitch/bombs/*.mdl", "GAME")) do
        if model == "models/gredwitch/bombs/" .. gredwitch then return false end
    end

    for _, gbombs in pairs(file.Find("models/gbombs/*.mdl", "GAME")) do
        if model == "models/gbombs/" .. gbombs then return false end
    end

    for _, phx in pairs(file.Find("models/props_phx/*.mdl", "GAME")) do
        if model == "models/props_phx/" .. phx then return false end
    end

    for _, mikeprops in pairs(file.Find("models/mikeprops/*.mdl", "GAME")) do
        if model == "models/mikeprops/" .. mikeprops then return false end
    end

    if table.HasValue(lia.config.BlackListedProps, model:lower()) then return false end
    return true
end

--------------------------------------------------------------------------------------------------------------------------
if sam then
    sam.config.set("Restrictions.Tool", false)
    sam.config.set("Restrictions.Limits", false)
    sam.config.set("Restrictions.Spawning", false)
end
--------------------------------------------------------------------------------------------------------------------------
