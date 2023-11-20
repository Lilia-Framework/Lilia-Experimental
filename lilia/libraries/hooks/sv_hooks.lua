----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local last_jump_time = 0
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:OnPickupMoney(client, moneyEntity)
    if moneyEntity and moneyEntity:IsValid() then
        local amount = moneyEntity:getAmount()
        client:getChar():giveMoney(amount)
        client:notifyLocalized("moneyTaken", lia.currency.get(amount))
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:EntityNetworkedVarChanged(entity, varName, oldVal, newVal)
    if varName == "Model" and entity.SetModel then hook.Run("PlayerModelChanged", entity, newVal) end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerUse(client, entity)
    if entity:isDoor() then
        local result = hook.Run("CanPlayerUseDoor", client, entity)
        if result == false then
            return false
        else
            result = hook.Run("PlayerUseDoor", client, entity)
            if result ~= nil then return result end
        end
    end
    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:KeyRelease(client, key)
    if key == IN_ATTACK2 then
        local wep = client:GetActiveWeapon()
        if IsValid(wep) and wep.IsHands and wep.ReadyToPickup then wep:Grab() end
    end

    if key == IN_RELOAD then timer.Remove("liaToggleRaise" .. client:SteamID()) end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerLoadedChar(client, character, lastChar)
    local identifier = "RemoveMatSpecular" .. client:SteamID()
    if timer.Exists(identifier) then timer.Remove(identifier) end
    timer.Create(
        identifier,
        30,
        0,
        function()
            if not IsValid(player) or not character then return end
            if not player:Alive() then return end
            RunConsoleCommand("mat_specular", 0)
        end
    )

    local timeStamp = os.date("%Y-%m-%d %H:%M:%S", os.time())
    lia.db.updateTable(
        {
            _lastJoinTime = timeStamp
        },
        nil,
        "characters",
        "_id = " .. character:getID()
    )

    if lastChar then
        local charEnts = lastChar:getVar("charEnts") or {}
        for _, v in ipairs(charEnts) do
            if v and IsValid(v) then v:Remove() end
        end

        lastChar:setVar("charEnts", nil)
    end

    if IsValid(client.liaRagdoll) then
        client.liaRagdoll.liaNoReset = true
        client.liaRagdoll.liaIgnoreDelete = true
        client.liaRagdoll:Remove()
    end

    local loginTime = os.time()
    character:setData("loginTime", loginTime)
    hook.Run("PlayerLoadout", client)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CharacterLoaded(id)
    local character = lia.char.loaded[id]
    if character then
        local client = character:getPlayer()
        if IsValid(client) then
            local uniqueID = "liaSaveChar" .. client:SteamID()
            timer.Create(
                uniqueID,
                300,
                0,
                function()
                    if IsValid(client) and client:getChar() then
                        client:getChar():save()
                    else
                        timer.Remove(uniqueID)
                    end
                end
            )
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerSay(client, message)
    if utf8.len(message) <= lia.config.MaxChatLength then
        local chatType, message, anonymous = lia.chat.parse(client, message, true)
        if (chatType == "ic") and lia.command.parse(client, message) then return "" end
        lia.chat.send(client, chatType, message, anonymous)
        hook.Run("PostPlayerSay", client, message, chatType, anonymous)
    else
        client:notify("Your message is too long and has not been sent.")
    end
    return ""
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:ShutDown()
    if hook.Run("ShouldDataBeSaved") == false then return end
    lia.shuttingDown = true
    hook.Run("SaveData")
    for _, v in ipairs(player.GetAll()) do
        v:saveLiliaData()
        if v:getChar() then v:getChar():save() end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:InitializedSchema()
    local persistString = GetConVar("sbox_persist"):GetString()
    if persistString == "" or string.StartWith(persistString, "lia_") then
        local newValue = "lia_" .. SCHEMA.folder
        game.ConsoleCommand("sbox_persist " .. newValue .. "\n")
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PrePlayerLoadedChar(client, character, lastChar)
    client:SetBodyGroups("000000000")
    client:SetSkin(0)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CharacterPreSave(character)
    local client = character:getPlayer()
    if not character:getInv() then return end
    for _, v in pairs(character:getInv():getItems()) do
        if v.onSave then v:call("onSave", client) end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CreateDefaultInventory(character)
    local charID = character:getID()
    if lia.inventory.types["grid"] then
        return         lia.inventory.instance(
            "grid",
            {
                char = charID
            }
        )
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:LiliaTablesLoaded()
    local ignore = function() print("") end
    lia.db.query("ALTER TABLE lia_players ADD COLUMN _firstJoin DATETIME"):catch(ignore)
    lia.db.query("ALTER TABLE lia_players ADD COLUMN _lastJoin DATETIME"):catch(ignore)
    lia.db.query("ALTER TABLE lia_items ADD COLUMN _quantity INTEGER"):catch(ignore)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:SetupMove(client, mv, cmd)
    if client:OnGround() and mv:KeyPressed(IN_JUMP) then
        local cur_time = CurTime()
        if cur_time - last_jump_time < lia.config.JumpCooldown then
            mv:SetButtons(bit.band(mv:GetButtons(), bit.bnot(IN_JUMP)))
        else
            last_jump_time = cur_time
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerThrowPunch(client, trace)
    local ent = client:GetTracedEntity()
    if not ent:IsPlayer() then return end
    if CAMI.PlayerHasAccess(client, "Lilia - Staff Permissions - One Punch Man", nil) and IsValid(ent) and client:Team() == FACTION_STAFF then
        client:ConsumeStamina(ent:getChar():getMaxStamina())
        ent:EmitSound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav", 70)
        client:setRagdolled(true, 10)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:ServerPostInit()
    local doors = ents.FindByClass("prop_door_rotating")
    for _, v in ipairs(doors) do
        local parent = v:GetOwner()
        if IsValid(parent) then
            v.liaPartner = parent
            parent.liaPartner = v
        else
            for _, v2 in ipairs(doors) do
                if v2:GetOwner() == v then
                    v2.liaPartner = v
                    v.liaPartner = v2
                    break
                end
            end
        end
    end

    for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
        if IsValid(v) and v:isDoor() then v:DrawShadow(false) end
    end

    lia.faction.formatModelData()
    timer.Simple(2, function() lia.entityDataLoaded = true end)
    lia.db.waitForTablesToLoad():next(
        function()
            hook.Run("LoadData")
            hook.Run("PostLoadData")
        end
    )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:KeyPress(client, key)
    if key == IN_ATTACK2 and IsValid(client.Grabbed) then
        client:DropObject(client.Grabbed)
        client.Grabbed = NULL
    end

    local entity = client:GetEyeTrace().Entity
    if not IsValid(entity) then return end
    if entity:isDoor() and entity:IsPlayer() and key == IN_USE then hook.Run("PlayerUse", client, entity) end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PreCleanupMap()
    lia.shuttingDown = true
    hook.Run("SaveData")
    hook.Run("PersistenceSave")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PostCleanupMap()
    lia.shuttingDown = false
    hook.Run("LoadData")
    hook.Run("PostLoadData")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:GetGameDescription()
    return lia.config.GamemodeName
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerSpray(client)
    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerDeathSound()
    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CanPlayerSuicide(client)
    return false
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:AllowPlayerPickup(client, entity)
    return false
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerShouldTakeDamage(client, attacker)
    return client:getChar() ~= nil
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
