------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanDeleteChar(_, char)
    if char:getMoney() < lia.config.DefaultMoney then return true end
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
    if client.LastDamaged and client.LastDamaged > CurTime() - 120 and client:isStaffOnDuty() then return false, "You took damage too recently to switch characters!" end
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