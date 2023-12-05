﻿
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnPlayerJoinClass(client, class, oldClass)
    local char = client:getChar()
    if char and lia.config.PermaClass then char:setData("pclass", class) end
    local info = lia.class.list[class]
    local info2 = lia.class.list[oldClass]
    if info.onSet then info:onSet(client) end
    if info2 and info2.onLeave then info2:onLeave(client) end
    netstream.Start(nil, "classUpdate", client)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanPlayerJoinClass(client, class, classTable)
    if classTable.isWhitelisted ~= true then return end
    local char = client:getChar()
    local wl = char:getData("whitelist", {})
    return wl[class] or false
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLoadedChar(client, character, _)
    local data = character:getData("pclass")
    local class = data and lia.class.list[data]
    if class and data then
        local oldClass = character:GetClass()
        if client:Team() == class.faction then
            timer.Simple(
                .3,
                function()
                    character:setClass(class.index)
                    hook.Run("OnPlayerJoinClass", client, class.index, oldClass)
                end
            )
        end
    end

    if character then
        for _, v in pairs(lia.class.list) do
            if (v.faction == client:Team()) and v.isDefault then
                character:setClass(v.index)
                break
            end
        end
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CheckFactionLimitReached(faction, _, client)
    if isfunction(faction.onCheckLimitReached) then return faction:onCheckLimitReached(character, client) end
    if not isnumber(faction.limit) then return false end
    local maxPlayers = faction.limit
    if faction.limit < 1 then maxPlayers = math.Round(#player.GetAll() * faction.limit) end
    return team.NumPlayers(faction.index) >= maxPlayers
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetDefaultCharName(client, faction)
    local info = lia.faction.indices[faction]
    if info and info.onGetDefaultName then return info:onGetDefaultName(client) end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetDefaultCharDesc(client, faction)
    local info = lia.faction.indices[faction]
    if info and info.onGetDefaultDesc then return info:onGetDefaultDesc(client) end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:FactionOnLoadout(client)
    local faction = lia.faction.indices[client:Team()]
    if not faction then return end
    if faction.scale then
        local scaleViewFix = faction.scale
        local scaleViewFixOffset = Vector(0, 0, 64)
        local scaleViewFixOffsetDuck = Vector(0, 0, 28)
        client:SetViewOffset(scaleViewFixOffset * faction.scale)
        client:SetViewOffsetDucked(scaleViewFixOffsetDuck * faction.scale)
        client:SetModelScale(scaleViewFix)
    else
        client:SetViewOffset(Vector(0, 0, 64))
        client:SetViewOffsetDucked(Vector(0, 0, 28))
        client:SetModelScale(1)
    end

    if faction.runSpeed then
        if faction.runSpeedMultiplier then
            client:SetRunSpeed(math.Round(lia.config.RunSpeed * faction.runSpeed))
        else
            client:SetRunSpeed(faction.runSpeed)
        end
    end

    if faction.walkSpeed then
        if faction.walkSpeedMultiplier then
            client:SetWalkSpeed(math.Round(lia.config.WalkSpeed * faction.walkSpeed))
        else
            client:SetWalkSpeed(faction.walkSpeed)
        end
    end

    if faction.jumpPower then
        if faction.jumpPowerMultiplier then
            client:SetJumpPower(math.Round(160 * faction.jumpPower))
        else
            client:SetJumpPower(faction.jumpPower)
        end
    end

    if faction.bloodcolor then
        client:SetBloodColor(faction.bloodcolor)
    else
        client:SetBloodColor(BLOOD_COLOR_RED)
    end

    if faction.health then
        client:SetMaxHealth(faction.health)
        client:SetHealth(faction.health)
    end

    if faction.armor then client:SetArmor(faction.armor) end
    if faction.weapons then
        for _, v in ipairs(faction.weapons) do
            client:Give(v)
        end
    end

    if faction.onSpawn then faction:onSpawn(client) end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ClassOnLoadout(client)
    local character = client:getChar()
    local class = lia.class.list[character:getClass()]
    if not class then return end
    if class.None then return end
    if class.scale then
        local scaleViewFix = class.scale
        local scaleViewFixOffset = Vector(0, 0, 64)
        local scaleViewFixOffsetDuck = Vector(0, 0, 28)
        client:SetViewOffset(scaleViewFixOffset * class.scale)
        client:SetViewOffsetDucked(scaleViewFixOffsetDuck * class.scale)
        client:SetModelScale(scaleViewFix)
    else
        client:SetViewOffset(Vector(0, 0, 64))
        client:SetViewOffsetDucked(Vector(0, 0, 28))
        client:SetModelScale(1)
    end

    if class.runSpeed then
        if class.runSpeedMultiplier then
            client:SetRunSpeed(math.Round(lia.config.RunSpeed * class.runSpeed))
        else
            client:SetRunSpeed(class.runSpeed)
        end
    end

    if class.walkSpeed then
        if class.walkSpeedMultiplier then
            client:SetWalkSpeed(math.Round(lia.config.WalkSpeed * class.walkSpeed))
        else
            client:SetWalkSpeed(class.walkSpeed)
        end
    end

    if class.jumpPower then
        if class.jumpPowerMultiplier then
            client:SetJumpPower(math.Round(160 * class.jumpPower))
        else
            client:SetJumpPower(class.jumpPower)
        end
    end

    if class.bloodcolor then
        client:SetBloodColor(class.bloodcolor)
    else
        client:SetBloodColor(BLOOD_COLOR_RED)
    end

    if class.health then
        client:SetMaxHealth(class.health)
        client:SetHealth(class.health)
    end

    if class.armor then client:SetArmor(class.armor) end
    if class.onSpawn then class:onSpawn(client) end
    if class.weapons then
        for _, v in ipairs(class.weapons) do
            client:Give(v)
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
