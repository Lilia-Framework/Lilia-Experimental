----------------------------------------------------------------------------------------------
function MODULE:PlayerDeath(client, inflictor, attacker)
    local char = client:getChar()
    if not char then return end
    if IsValid(client.liaRagdoll) then
        client.liaRagdoll.liaIgnoreDelete = true
        client.liaRagdoll:Remove()
        client:setLocalVar("blur", nil)
    end

    char:setData("deathPos", client:GetPos())
    client:setNetVar("deathStartTime", CurTime())
    client:setNetVar("deathTime", CurTime() + 5)
    if lia.config.DeathPopupEnabled then
        net.Start("death_client")
        net.WriteString(attacker:Nick())
        net.WriteFloat(attacker:getChar():getID())
        net.Send(client)
    end

    if (attacker:IsPlayer() and lia.config.LoseWeapononDeathHuman) or (not attacker:IsPlayer() and lia.config.LoseWeapononDeathNPC) or (lia.config.LoseWeapononDeathWorld and attacker:IsWorld()) then
        self:RemoveAllEquippedWeapons(client)
    end
end

----------------------------------------------------------------------------------------------
function MODULE:RemoveAllEquippedWeapons(client)
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

----------------------------------------------------------------------------------------------
function MODULE:PlayerDeathThink(client)
    if client:getChar() then
        local deathTime = client:getNetVar("deathTime")
        if deathTime and deathTime <= CurTime() then
            client:Spawn()
        end
    end

    return false
end
----------------------------------------------------------------------------------------------