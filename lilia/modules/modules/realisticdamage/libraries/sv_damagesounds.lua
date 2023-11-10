--------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerDeath(client)
    if not lia.config.DeathSoundEnabled then return end
    local deathSound = hook.Run("GetPlayerDeathSound", client, client:isFemale())
    if deathSound then client:EmitSound(deathSound) end
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:GetPlayerDeathSound(client, isFemale)
    local soundTable
    soundTable = isFemale and lia.config.FemaleDeathSounds or lia.config.MaleDeathSounds
    return soundTable and soundTable[math.random(#soundTable)]
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:GetPlayerPainSound(client, paintype, isFemale)
    local soundTable
    if paintype == "drown" then
        soundTable = isFemale and lia.config.FemaleDrownSounds or lia.config.MaleDrownSounds
    elseif paintype == "hurt" then
        soundTable = isFemale and lia.config.FemaleHurtSounds or lia.config.MaleHurtSounds
    end
    return soundTable and soundTable[math.random(#soundTable)]
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:EntityTakeDamage(target, dmginfo)
    if not (target:IsPlayer() or IsValid(target)) then return end
    local attacker = dmgInfo:GetAttacker()
    if lia.config.PainSoundEnabled and client:IsPlayer() and client:Health() >= 0 then
        local painSound = self:GetPlayerPainSound(client, "hurt", client:isFemale())
        if client:WaterLevel() >= 3 then painSound = self:GetPlayerPainSound(client, "drown", client:isFemale()) end
        if painSound then
            client:EmitSound(painSound)
            client.NextPain = CurTime() + 0.33
        end
    end

    if not dmgInfo:IsFallDamage() and IsValid(attacker) and attacker:IsPlayer() and attacker ~= target and target:Team() ~= FACTION_STAFF then target.LastDamaged = CurTime() end
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:EntityTakeDamage(target, dmginfo)
    local attacker = dmgInfo:GetAttacker()
    local char = attacker:getChar()
    local weapon = attacker:GetActiveWeapon()
    local damage = dmginfo:GetDamage()
    local strbonus = hook.Run("GetStrengthBonusDamage", char)
    local inflictor = dmgInfo:GetInflictor()
    if attacker:IsPlayer() and IsValid(attacker) and IsValid(weapon) and table.HasValue(lia.config.MeleeWeapons, weapon:GetClass()) and lia.config.MeleeDamageBonus then dmginfo:SetDamage(damage + strbonus) end
    if lia.config.AntiPropKillEnabled then
        if IsValid(attacker) and dmgInfo:IsDamageType(DMG_CRUSH) and not IsValid(target.liaRagdoll) and (attacker:GetClass() == "prop_physics" or IsValid(inflictor) and inflictor:GetClass() == "prop_physics") then return true end
        if IsValid(target.liaPlayer) then
            if dmgInfo:IsDamageType(DMG_CRUSH) then
                if (target.liaFallGrace or 0) < CurTime() then
                    if dmgInfo:GetDamage() <= 10 then dmgInfo:SetDamage(0) end
                    target.liaFallGrace = CurTime() + 0.5
                else
                    return
                end
            end

            target.liaPlayer:TakeDamageInfo(dmgInfo)
        end
    end

    if lia.config.CarRagdoll and IsValid(inflictor) and (inflictor:GetClass() == "gmod_sent_vehicle_fphysics_base" or inflictor:GetClass() == "gmod_sent_vehicle_fphysics_wheel") and not IsValid(target:GetVehicle()) then
        dmgInfo:ScaleDamage(0)
        if not IsValid(target.liaRagdoll) then target:setRagdolled(true, 5) end
    end
end
--------------------------------------------------------------------------------------------------------------------------
