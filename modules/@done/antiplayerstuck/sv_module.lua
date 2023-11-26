﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanCollide(ent1, ent2)
    local ShouldCollide = hook.Run("ShouldCollide", ent1, ent2)
    if ShouldCollide == nil then ShouldCollide = true end
    return ShouldCollide
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ShouldCheck(client)
    return IsValid(client) and client:IsPlayer() and client:Alive() and not client:InVehicle() and not client:IsNoClipping() and client:IsSolid()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CheckIfPlayerStuck()
    for _, client in ipairs(player.GetAll()) do
        if self:ShouldCheck(client) then
            local Offset = Vector(5, 5, 5)
            local Stuck = false
            if client.Stuck then Offset = Vector(2, 2, 2) end
            for _, ent in pairs(ents.FindInBox(client:GetPos() + client:OBBMins() + Offset, client:GetPos() + client:OBBMaxs() - Offset)) do
                if self:ShouldCheck(ent) and ent ~= client and self:CanCollide(client, ent) then
                    client:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                    local velocity = ent:GetForward() * 200
                    client:SetVelocity(velocity)
                    ent:SetVelocity(-velocity)
                    Stuck = true
                end
            end

            if not Stuck then
                client.Stuck = false
                if client:GetCollisionGroup() ~= COLLISION_GROUP_PLAYER then
                    client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
                    MsgC(Color(255, 155, 0), "[ANTI-STUCK] ", Color(255, 255, 255), "Changing collision group back to player for: " .. client:Nick())
                end
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ShouldCollide(ent1, ent2)
    if table.HasValue(lia.config.BlockedCollideEntities, ent1:GetClass()) and table.HasValue(lia.config.BlockedCollideEntities, ent2:GetClass()) then return false end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
timer.Create("CheckIfPlayerStuck", 4, 0, function() MODULE:CheckIfPlayerStuck() end)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------