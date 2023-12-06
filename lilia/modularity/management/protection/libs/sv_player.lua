------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(client)
    if client:IsBot() then
        local botID = os.time()
        local index = math.random(1, table.Count(lia.faction.indices))
        local faction = lia.faction.indices[index]
        local inventory = lia.inventory.new("grid")
        local character = lia.char.new(
            {
                name = client:Name(),
                faction = faction and faction.uniqueID or "unknown",
                desc = "This is a bot. BotID is " .. botID .. ".",
                model = "models/gman.mdl",
            },
            botID,
            client,
            client:SteamID64()
        )

        character.isBot = true
        character.vars.inv = {}
        inventory.id = "bot" .. character:getID()
        character.vars.inv[1] = inventory
        lia.inventory.instances[inventory.id] = inventory
        lia.char.loaded[botID] = character
        character:setup()
        client:Spawn()
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerDisconnected(client)
    client:saveLiliaData()
    local character = client:getChar()
    if character then
        local charEnts = character:getVar("charEnts") or {}
        for _, v in ipairs(charEnts) do
            if v and IsValid(v) then v:Remove() end
        end

        hook.Run("OnCharDisconnect", client, character)
        character:save()
    end

    if IsValid(client.liaRagdoll) then
        client.liaRagdoll.liaNoReset = true
        client.liaRagdoll.liaIgnoreDelete = true
        client.liaRagdoll:Remove()
    end

    lia.char.cleanUpForPlayer(client)
    for _, entity in pairs(ents.GetAll()) do
        if entity:GetCreator() == client then entity:Remove() end
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
