------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PostPlayerLoadout(client)
    local uniqueID = "StamCheck" .. client:SteamID()
    local character = client:getChar()
    if character and character:getInv() then
        lia.attribs.setup(client)
        for _, item in pairs(character:getInv():getItems()) do
            item:call("onLoadout", client)
            if item:getData("equip") and istable(item.attribBoosts) then
                for attribute, boost in pairs(item.attribBoosts) do
                    character:addBoost(item.uniqueID, attribute, boost)
                end
            end
        end
    end

    timer.Create(
        uniqueID,
        0.25,
        0,
        function()
            if not IsValid(client) then
                timer.Remove(uniqueID)
                return
            end

            self:CalcStaminaChange(client)
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLoadedChar(client, character)
    local maxstm = character:getMaxStamina()
    timer.Simple(0.25, function() client:setLocalVar("stamina", maxstm) end)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerStaminaLost(client)
    if client.isBreathing then return end
    client:EmitSound("player/breathe1.wav", 35, 100)
    client.isBreathing = true
    timer.Create(
        "liaStamBreathCheck" .. client:SteamID(),
        1,
        0,
        function()
            if client:getLocalVar("stamina", 0) < self.StaminaBreathingThreshold then return end
            client:StopSound("player/breathe1.wav")
            client.isBreathing = nil
            timer.Remove("liaStamBreathCheck" .. client:SteamID())
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerThrowPunch(client, _)
    local ent = client:GetTracedEntity()
    if ent:IsPlayer() and CAMI.PlayerHasAccess(client, "Staff Permissions - One Punch Man", nil) and IsValid(ent) and client:isStaffOnDuty() then
        client:ConsumeStamina(ent:getChar():getMaxStamina())
        ent:EmitSound("weapons/crowbar/crowbar_impact" .. math.random(1, 2) .. ".wav", 70)
        client:setRagdolled(true, 10)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnCharAttribBoosted(client, character, attribID)
    local attribute = lia.attribs.list[attribID]
    if attribute and isfunction(attribute.onSetup) then attribute:onSetup(client, character:getAttrib(attribID, 0)) end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------