------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:isSuitableForTrunk(ent)
    if IsValid(ent) and ent:IsVehicle() then return true end
    return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializeStorage(ent)
    if LiliaStorage.Vehicles[ent] then return end
    LiliaStorage.Vehicles[ent] = true
    ent.getInv = function(selfent) return lia.inventory.instances[selfent:getNetVar("inv")] end
    ent.getStorageInfo = function(_) return LiliaStorage.VehicleTrunk end
    if SERVER then
        ent.receivers = {}
        lia.inventory.instance(LiliaStorage.VehicleTrunk.invType, LiliaStorage.VehicleTrunk.invData):next(
            function(inv)
                inv.isStorage = true
                ent:setNetVar("inv", inv:getID())
                hook.Run("StorageInventorySet", self, inv)
            end
        )
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
