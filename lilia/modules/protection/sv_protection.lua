------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPlayerDropWeapon(client, item, entity)
    local physObject = entity:GetPhysicsObject()
    if physObject then physObject:EnableMotion() end
    timer.Simple(lia.config.TimeUntilDroppedSWEPRemoved, function() if entity and entity:IsValid() then entity:Remove() end end)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanDeleteChar(client, char)
    if char:getMoney() < lia.config.DefaultMoney then return true end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnEntityCreated(entity)
    if lia.config.DrawEntityShadows then entity:DrawShadow(false) end
    if entity:GetClass() == "prop_vehicle_prisoner_pod" then
        entity:AddEFlags(EFL_NO_THINK_FUNCTION)
        entity.nicoSeat = true
    end

    if entity:IsWidget() then hook.Add("PlayerTick", "GODisableEntWidgets2", function(entity, n) widgets.PlayerTick(entity, n) end) end
    if not entity:IsRagdoll() then return end
    if entity:getNetVar("player", nil) then return end
    timer.Simple(
        300,
        function()
            if not IsValid(entity) then return end
            entity:SetSaveValue("m_bFadingOut", true)
            timer.Simple(
                3,
                function()
                    if not IsValid(entity) then return end
                    entity:Remove()
                end
            )
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CheckValidSit(client, trace)
    local entity = client:GetTracedEntity()
    if entity:IsVehicle() or entity:IsPlayer() then return false end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedVehicle(client, entity)
    local delay = lia.config.PlayerSpawnVehicleDelay
    if not client:IsSuperAdmin() then client.NextVehicleSpawn = SysTime() + delay end
    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPhysgunFreeze(weapon, physObj, entity, client)
    if not physObj:IsMoveable() then return false end
    if entity:GetUnFreezable() then return false end
    physObj:EnableMotion(false)
    if entity:GetClass() == "prop_vehicle_jeep" then
        local objects = entity:GetPhysicsObjectCount()
        for i = 0, objects - 1 do
            entity:GetPhysicsObjectNum(i):EnableMotion(false)
        end
    end

    client:AddFrozenPhysicsObject(entity, physObj)
    client:SendHint("PhysgunUnfreeze", 0.3)
    client:SuppressHint("PhysgunFreeze")
    return true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedNPC(client, entity)
    if lia.config.NPCsDropWeapons then entity:SetKeyValue("spawnflags", "8192") end
    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerDisconnected(client)
    client:saveLiliaData()
    local character = client:getChar()
    if character then
        local charEnts = character:getVar("charEnts") or {}
        for _, v in ipairs(charEnts) do
            if v and IsValid(v) then v:Remove() end
        end

        hook.Run("OnCharDisconnect", client, character)
        character:save()
    end

    if IsValid(client.liaRagdoll) then
        client.liaRagdoll.liaNoReset = true
        client.liaRagdoll.liaIgnoreDelete = true
        client.liaRagdoll:Remove()
    end

    lia.char.cleanUpForPlayer(client)
    for _, entity in pairs(ents.GetAll()) do
        if entity:GetCreator() == client then entity:Remove() end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPhysgunPickup(client, entity)
    if entity:GetClass() == "prop_physics" and entity:GetCollisionGroup() == COLLISION_GROUP_NONE then entity:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR) end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnObject(client, model, skin)
    if CAMI.PlayerHasAccess(client, "Lilia - Spawn Permissions - No Spawn Delay", nil) and (client.AdvDupe2 and client.AdvDupe2.Pasting) then return true end
    if (client.NextSpawn or 0) < CurTime() then
        client.NextSpawn = CurTime() + 0.75
    else
        client:notify("You can't spawn props that fast!")
        return false
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PhysgunDrop(client, entity)
    if entity:GetClass() ~= "prop_physics" then return end
    timer.Simple(5, function() if IsValid(entity) and entity:GetCollisionGroup() == COLLISION_GROUP_PASSABLE_DOOR then entity:SetCollisionGroup(COLLISION_GROUP_NONE) end end)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedEffect(client, model, entity)
    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedRagdoll(client, model, entity)
    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedSENT(client, entity)
    if not client then return true end
    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedProp(client, model, entity)
    for _, gredwitch in pairs(file.Find("models/gredwitch/bombs/*.mdl", "GAME")) do
        if model == "models/gredwitch/bombs/" .. gredwitch then
            entity:Remove()
            return
        end
    end

    for _, gbombs in pairs(file.Find("models/gbombs/*.mdl", "GAME")) do
        if model == "models/gbombs/" .. gbombs then
            entity:Remove()
            return
        end
    end

    for _, phx in pairs(file.Find("models/props_phx/*.mdl", "GAME")) do
        if model == "models/props_phx/" .. phx then
            entity:Remove()
            return
        end
    end

    for _, mikeprops in pairs(file.Find("models/mikeprops/*.mdl", "GAME")) do
        if model == "models/mikeprops/" .. mikeprops then
            entity:Remove()
            return
        end
    end

    self:PlayerSpawnedEntity(client, entity)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerSpawnedEntity(client, entity)
    entity:SetCreator(client)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanPlayerUseChar(client, newcharacter)
    local currentChar = client:getChar()
    local faction = lia.faction.indices[newcharacter:getFaction()]
    local banned = newcharacter:getData("banned")
    if newcharacter and newcharacter:getData("banned", false) then
        if isnumber(banned) and banned < os.time() then return end
        return false, "@charBanned"
    end

    if faction and hook.Run("CheckFactionLimitReached", faction, newcharacter, client) then return false, "@limitFaction" end
    if currentChar then
        local status, result = hook.Run("CanPlayerSwitchChar", client, currentChar, newcharacter)
        if status == false then return status, result end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanPlayerSwitchChar(client, character, newCharacter)
    if IsValid(client.liaRagdoll) then return false, "You are ragdolled!" end
    if not client:Alive() then return false, "You are dead!" end
    if client.LastDamaged and client.LastDamaged > CurTime() - 120 and character:getFaction() ~= FACTION_STAFF then return false, "You took damage too recently to switch characters!" end
    if lia.config.CharacterSwitchCooldown and (character:getData("loginTime", 0) + lia.config.CharacterSwitchCooldownTimer) > os.time() then return false, "You are on cooldown!" end
    if character:getID() == newCharacter:getID() then return false, "You are already using this character!" end
    return true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnCharFallover(client, entity, bFallenOver)
    bFallenOver = bFallenOver or false
    if IsValid(entity) then
        entity:SetCollisionGroup(COLLISION_GROUP_NONE)
        entity:SetCustomCollisionCheck(false)
    end

    client:setNetVar("fallingover", bFallenOver)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("VJSay", function(len, ply) ServerLog("Attempted backdoor " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_testentity_runtextsd", function(len, ply) ServerLog("Attempted backdoor 2 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_fireplace_turnon1", function(len, ply) ServerLog("Attempted backdoor 3 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_fireplace_turnon2", function(len, ply) ServerLog("Attempted backdoor 4 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcmover_sv_create", function(len, ply) ServerLog("Attempted backdoor 5 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcmover_sv_startmove", function(len, ply) ServerLog("Attempted backdoor 6 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcmover_removesingle", function(len, ply) ServerLog("Attempted backdoor 7 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcmover_removeall", function(len, ply) ServerLog("Attempted backdoor 8 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcrelationship_sr_leftclick", function(len, ply) ServerLog("Attempted backdoor 9 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("vj_npcspawner_sv_create", function(len, ply) ServerLog("Attempted backdoor 10 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
net.Receive("GExtension_Net_GroupData", function(len, ply) ServerLog("Attempted backdoor 11 " .. ply:SteamID()) end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
