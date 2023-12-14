------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
﻿----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:syncCharList(client)
    if not client.liaCharList then return end
    net.Start("liaCharList")
    net.WriteUInt(#client.liaCharList, 32)
    for i = 1, #client.liaCharList do
        net.WriteUInt(client.liaCharList[i], 32)
    end

    net.Send(client)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLiliaDataLoaded(client)
    lia.char.restore(
        client,
        function(charList)
            if not IsValid(client) then return end
            MsgN("Loaded (" .. table.concat(charList, ", ") .. ") for " .. client:Name())
            for k, v in ipairs(charList) do
                if lia.char.loaded[v] then
                    lia.char.loaded[v]:sync(client)
                end
            end

            for k, v in ipairs(player.GetAll()) do
                if v:getChar() then
                    v:getChar():sync(client)
                end
            end

            client.liaCharList = charList
            self:syncCharList(client)
            client.liaLoaded = true
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CanPlayerUseChar(client, newcharacter)
    local currentChar = client:getChar()
    local faction = lia.faction.indices[newcharacter:getFaction()]
    local banned = newcharacter:getData("banned")
    if currentChar and currentChar:getID() == newcharacter:getID() then return false, "@usingChar" end
    if newcharacter and newcharacter:getData("banned", false) then
        if isnumber(banned) and banned < os.time() then return end

        return false, "@charBanned"
    end

    if faction and hook.Run("CheckFactionLimitReached", faction, newcharacter, client) then return false, "@limitFaction" end
    if currentChar then
        local status, result = hook.Run("CanPlayerSwitchChar", client, currentChar, newcharacter)
        if status == false then return status, result end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLoadedChar(client, character, oldCharacter)
    client:Spawn()
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnCharacterDelete(client, id)
    lia.log.add(client, "charDelete", id)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnCharCreated(client, character)
    local id = character:getID()
    lia.log.add(client, "charCreate", character)
    MsgN("Created character '" .. id .. "' for " .. client:steamName() .. ".")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CharacterLoaded(id)
    local character = lia.char.loaded[id]
    local client = character:getPlayer()
    lia.log.add(client, "charLoad", id, character:getName())
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------