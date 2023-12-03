﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerGetFistDamage(client, _, context)
    local char = client:getChar()
    local strbonus = hook.Run("GetPunchStrengthBonusDamage", char)
    if client:getChar() then context.damage = context.damage + strbonus end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerThrowPunch(client, _)
    local ent = client:GetTracedEntity()
    if not ent:IsPlayer() then return end
    if CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - One Punch Man", nil) and IsValid(ent) and client:isStaffOnDuty() then
        client:ConsumeStamina(ent:getChar():getMaxStamina())
        ent:EmitSound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav", 70)
        client:setRagdolled(true, 10)
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
