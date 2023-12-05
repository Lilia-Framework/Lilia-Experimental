﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CharacterPreSave(character)
    local client = character:getPlayer()
    if lia.config.SaveCharacterAmmo then
        local ammoTable = {}
        for _, ammoType in pairs(game.GetAmmoTypes()) do
            local ammoCount = client:GetAmmoCount(ammoType.name)
            if ammoCount > 0 then ammoTable[ammoType.name] = ammoCount end
        end

        character:setData("ammo", ammoTable)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLoadedChar(client)
    local character = client:getChar()
    local ammoTable = character:getData("ammo", {})
    timer.Simple(
        0.25,
        function()
            if lia.config.SaveCharacterAmmo then
                for ammoType, ammoCount in pairs(ammoTable) do
                    client:GiveAmmo(ammoCount, ammoType, true)
                end

                character:setData("ammo", nil)
            end
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerDeath(client, _, _)
    if not client:getChar() then return end
    local char = client:getChar()
    local inventory = char:getInv()
    local items = inventory:getItems()
    if inventory and not lia.config.KeepAmmoOnDeath then
        for _, v in pairs(items) do
            if (v.isWeapon or v.isCW) and v:getData("equip") then v:setData("ammo", nil) end
        end
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
