------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DeathSettingsCore:PlayerDeath(client, _, attacker)
    local char = client:getChar()
    if not char then return end
    if self.DeathPopupEnabled then
        net.Start("death_client")
        net.WriteString(attacker:Nick())
        net.WriteFloat(attacker:getChar():getID())
        net.Send(client)
    end

    if (attacker:IsPlayer() and self.LoseWeapononDeathHuman) or (not attacker:IsPlayer() and self.LoseWeapononDeathNPC) or (self.LoseWeapononDeathWorld and attacker:IsWorld()) then self:RemoveAllEquippedWeapons(client) end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DeathSettingsCore:RemoveAllEquippedWeapons(client)
    local char = client:getChar()
    local inventory = char:getInv()
    local items = inventory:getItems()
    client.carryWeapons = {}
    client.LostItems = {}
    for _, v in pairs(items) do
        if (v.isWeapon or v.isCW) and v:getData("equip") then
            table.insert(client.LostItems, v.uniqueID)
            v:remove()
        end
    end

    if #client.LostItems > 0 then
        local amount = #client.LostItems > 1 and #client.LostItems .. " items" or "an item"
        client:notify("Because you died, you have lost " .. amount .. ".")
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
