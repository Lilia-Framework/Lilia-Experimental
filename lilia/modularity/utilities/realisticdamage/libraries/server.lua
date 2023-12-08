﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ScalePlayerDamage(_, hitgroup, dmgInfo)
    local damageScale = self.DamageScale
    if hitgroup == HITGROUP_HEAD then
        damageScale = self.HeadShotDamage
    elseif table.HasValue(self.LimbHitgroups, hitgroup) then
        damageScale = self.LimbDamage
    end

    dmgInfo:ScaleDamage(damageScale)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerDeath(client)
    if not self.DeathSoundEnabled then return end
    local deathSound = hook.Run("GetPlayerDeathSound", client, client:isFemale())
    if deathSound then
        client:EmitSound(deathSound)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:EntityTakeDamage(client, _)
    if not self.PainSoundEnabled or not client:IsPlayer() or client:Health() <= 0 then return end
    local painSound = self:GetPlayerPainSound(client, "hurt", client:isFemale())
    if client:WaterLevel() >= 3 then
        painSound = self:GetPlayerPainSound(client, "drown", client:isFemale())
    end

    if painSound then
        client:EmitSound(painSound)
        client.NextPain = CurTime() + 0.33
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HandleDrowning(client)
    if not client:getChar() or not client:Alive() or hook.Run("ShouldclientDrown", client) == false then return end
    if client:WaterLevel() >= 3 then
        client.drowningTime = client.drowningTime or (CurTime() + MODULE.DrownTime)
        client.nextDrowning = client.nextDrowning or CurTime()
        client.drownDamage = client.drownDamage or 0
        if client.drowningTime < CurTime() and client.nextDrowning < CurTime() then
            client:ScreenFade(1, Color(0, 0, 255, 100), 1, 0)
            client:TakeDamage(MODULE.DrownDamage)
            client.drownDamage = client.drownDamage + MODULE.DrownDamage
            client.nextDrowning = CurTime() + 1
        end
    else
        client.drowningTime = nil
        client.nextDrowning = nil
        if client.nextRecover and client.nextRecover < CurTime() and client.drownDamage > 0 then
            client.drownDamage = client.drownDamage - MODULE.DrownDamage
            client:SetHealth(math.Clamp(client:Health() + MODULE.DrownDamage, 0, client:GetMaxHealth()))
            client.nextRecover = CurTime() + 1
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
timer.Create(
    "LifeGuard",
    1,
    0,
    function()
        if not MODULE.DrowningEnabled then return end
        for _, client in ipairs(player.GetAll()) do
            HandleDrowning(client)
        end
    end
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------