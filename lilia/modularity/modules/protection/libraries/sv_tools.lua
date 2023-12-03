------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPhysgunPickup(_, entity)
    if entity:GetClass() == "prop_physics" and entity:GetCollisionGroup() == COLLISION_GROUP_NONE then
        entity:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PhysgunDrop(_, entity)
    if entity:GetClass() ~= "prop_physics" then return end
    timer.Simple(
        5,
        function()
            if IsValid(entity) and entity:GetCollisionGroup() == COLLISION_GROUP_PASSABLE_DOOR then
                entity:SetCollisionGroup(COLLISION_GROUP_NONE)
            end
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPhysgunFreeze(_, physObj, entity, client)
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