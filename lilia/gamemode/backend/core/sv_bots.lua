--------------------------------------------------------------------------------------------------------------------------
function GM:SetupBotCharacter(client)
    local botID = os.time()
    local index = math.random(1, table.Count(lia.faction.indices))
    local faction = lia.faction.indices[index]
    local character = lia.char.new(
        {
            name = client:Name(),
            faction = faction and faction.uniqueID or "unknown",
            desc = "This is a bot. BotID is " .. botID .. ".",
            model = "models/gman.mdl",
        }, botID, client, client:SteamID64()
    )

    character.isBot = true
    character.vars.inv = {}
    hook.Run("SetupBotInventory", client, character)
    lia.char.loaded[botID] = character
    character:setup()
    client:Spawn()
end

--------------------------------------------------------------------------------------------------------------------------
function GM:SetupBotInventory(client, character)
    local inventory = lia.inventory.new("grid")
    inventory.id = "bot" .. character:getID()
    character.vars.inv[1] = inventory
    lia.inventory.instances[inventory.id] = inventory
end
--------------------------------------------------------------------------------------------------------------------------