----------------------------------------------------------------------------------------------
function MODULE:PlayerLoadout(client)
    local character = client:getChar()
    if client.liaSkipLoadout then
        client.liaSkipLoadout = nil
        return
    end

    if not client:getChar() then
        client:SetNoDraw(true)
        client:Lock()
        client:SetNotSolid(true)
        return
    end

    client:SetWeaponColor(Vector(0.30, 0.80, 0.10))
    client:StripWeapons()
    client:setLocalVar("blur", nil)
    client:SetModel(character:getModel())
    client:SetWalkSpeed(lia.config.WalkSpeed)
    client:SetRunSpeed(lia.config.RunSpeed)
    client:SetJumpPower(160)
    hook.Run("ClassOnLoadout", client)
    hook.Run("FactionOnLoadout", client)
    lia.flag.onSpawn(client)
    hook.Run("PostPlayerLoadout", client)
    client:SelectWeapon("lia_hands")
end

----------------------------------------------------------------------------------------------
function MODULE:PlayerSpawn(client)
    client:SetNoDraw(false)
    client:UnLock()
    client:SetNotSolid(false)
    client:setAction()
    hook.Run("PlayerLoadout", client)
end

----------------------------------------------------------------------------------------------
function MODULE:OnCharAttribBoosted(client, character, attribID)
    local attribute = lia.attribs.list[attribID]
    if attribute and isfunction(attribute.onSetup) then attribute:onSetup(client, character:getAttrib(attribID, 0)) end
end

----------------------------------------------------------------------------------------------
function MODULE:PostPlayerLoadout(client)
    local character = client:getChar()
    client:Give("lia_hands")
    client:SetupHands()
    lia.attribs.setup(client)
    if character:getInv() then
        for _, item in pairs(character:getInv():getItems()) do
            item:call("onLoadout", client)
            if item:getData("equip") and istable(item.attribBoosts) then
                for attribute, boost in pairs(item.attribBoosts) do
                    character:addBoost(item.uniqueID, attribute, boost)
                end
            end
        end
    end
end

----------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(client)
    client.liaJoinTime = RealTime()
    client:loadLiliaData(
        function(data)
            if not IsValid(client) then return end
            local address = client:IPAddress()
            client:setLiliaData("lastIP", address)
            netstream.Start(client, "liaDataSync", data, client.firstJoin, client.lastJoin)
            for _, v in pairs(lia.item.instances) do
                if v.entity and v.invID == 0 then v:sync(client) end
            end

            hook.Run("PlayerLiliaDataLoaded", client)
        end
    )

    hook.Run("PostPlayerInitialSpawn", client)
end

----------------------------------------------------------------------------------------------
function MODULE:PostPlayerInitialSpawn(client)
    client:SetNoDraw(true)
    client:SetNotSolid(true)
    client:Lock()
    timer.Simple(
        1,
        function()
            if not IsValid(client) then return end
            client:KillSilent()
            client:StripAmmo()
        end
    )
end
----------------------------------------------------------------------------------------------
