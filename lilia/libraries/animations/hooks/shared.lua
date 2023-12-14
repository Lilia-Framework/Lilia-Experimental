﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GM = GM or GAMEMODE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local vectorAngle = FindMetaTable("Vector").Angle
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local oldCalcSeqOverride
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:TranslateActivity(client, act)
    local model = string.lower(client.GetModel(client))
    local class = lia.anim.getModelClass(model) or "player"
    local weapon = client.GetActiveWeapon(client)
    if class == "player" then
        if not MODULE.WepAlwaysRaised and IsValid(weapon) and (client.isWepRaised and not client.isWepRaised(client)) and client:OnGround() then
            if string.find(model, "zombie") then
                local tree = lia.anim.zombie
                if string.find(model, "fast") then
                    tree = lia.anim.fastZombie
                end

                if tree[act] then return tree[act] end
            end

            local holdType = IsValid(weapon) and (weapon.HoldType or weapon.GetHoldType(weapon)) or "normal"
            holdType = lia.config.PlayerHoldTypeTranslator[holdType] or "passive"
            local tree = lia.anim.player[holdType]
            if tree and tree[act] then
                if isstring(tree[act]) then
                    client.CalcSeqOverride = client.LookupSequence(tree[act])

                    return
                else
                    return tree[act]
                end
            end
        end

        return self.BaseClass.TranslateActivity(self.BaseClass, client, act)
    end

    local tree = lia.anim[class]
    if tree then
        local subClass = "normal"
        if client.InVehicle(client) then
            local vehicle = client.GetVehicle(client)
            local class = vehicle:isChair() and "chair" or vehicle:GetClass()
            if tree.vehicle and tree.vehicle[class] then
                local act = tree.vehicle[class][1]
                local fixvec = tree.vehicle[class][2]
                if fixvec then
                    client:SetLocalPos(Vector(16.5438, -0.1642, -20.5493))
                end

                if isstring(act) then
                    client.CalcSeqOverride = client.LookupSequence(client, act)

                    return
                else
                    return act
                end
            else
                act = tree.normal[ACT_MP_CROUCH_IDLE][1]
                if isstring(act) then
                    client.CalcSeqOverride = client:LookupSequence(act)
                end

                return
            end
        elseif client.OnGround(client) then
            client.ManipulateBonePosition(client, 0, vector_origin)
            if IsValid(weapon) then
                subClass = weapon.HoldType or weapon.GetHoldType(weapon)
                subClass = lia.config.HoldTypeTranslator[subClass] or subClass
            end

            if tree[subClass] and tree[subClass][act] then
                local index = (not client.isWepRaised or client:isWepRaised()) and 2 or 1
                local act2 = tree[subClass][act][index]
                if isstring(act2) then
                    client.CalcSeqOverride = client.LookupSequence(client, act2)

                    return
                end

                return act2
            end
        elseif tree.glide then
            return tree.glide
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:DoAnimationEvent(client, event, data)
    local class = lia.anim.getModelClass(client:GetModel())
    if class == "player" then
        return self.BaseClass:DoAnimationEvent(client, event, data)
    else
        local weapon = client:GetActiveWeapon()
        if IsValid(weapon) then
            local holdType = weapon.HoldType or weapon:GetHoldType()
            holdType = lia.config.HoldTypeTranslator[holdType] or holdType
            local animation = lia.anim[class][holdType]
            if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
                client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

                return ACT_VM_PRIMARYATTACK
            elseif event == PLAYERANIMEVENT_ATTACK_SECONDARY then
                client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.attack or ACT_GESTURE_RANGE_ATTACK_SMG1, true)

                return ACT_VM_SECONDARYATTACK
            elseif event == PLAYERANIMEVENT_RELOAD then
                client:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, animation.reload or ACT_GESTURE_RELOAD_SMG1, true)

                return ACT_INVALID
            elseif event == PLAYERANIMEVENT_JUMP then
                client.m_bJumping = true
                client.m_bFistJumpFrame = true
                client.m_flJumpStartTime = CurTime()
                client:AnimRestartMainSequence()

                return ACT_INVALID
            elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
                client:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)

                return ACT_INVALID
            end
        end
    end

    return ACT_INVALID
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:HandlePlayerLanding(client, velocity, wasOnGround)
    if client:IsNoClipping() then return end
    if client:IsOnGround() and not wasOnGround then
        local length = (client.lastVelocity or velocity):LengthSqr()
        local animClass = lia.anim.getModelClass(client:GetModel())
        if animClass ~= "player" and length < 100000 then return end
        client:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)

        return true
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CalcMainActivity(client, velocity)
    client.CalcIdeal = ACT_MP_STAND_IDLE
    oldCalcSeqOverride = client.CalcSeqOverride
    client.CalcSeqOverride = -1
    local animClass = lia.anim.getModelClass(client:GetModel())
    if animClass ~= "player" then
        client:SetPoseParameter("move_yaw", math.NormalizeAngle(vectorAngle(velocity)[2] - client:EyeAngles()[2]))
    end

    if not self:HandlePlayerLanding(client, velocity, client.m_bWasOnGround) then
        local len2D = velocity:Length2DSqr()
        if len2D > 22500 then
            client.CalcIdeal = ACT_MP_RUN
        elseif len2D > 0.25 then
            client.CalcIdeal = ACT_MP_WALK
        end
    end

    client.m_bWasOnGround = client:IsOnGround()
    client.m_bWasNoclipping = client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle()
    client.lastVelocity = velocity
    if CLIENT then
        client:SetIK(false)
    end

    return client.CalcIdeal, client.liaForceSeq or oldCalcSeqOverride
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:InitializedModules()
    for _, model in pairs(lia.config.PlayerModelTposingFixer) do
        lia.anim.setModelClass(model, "player")
    end

    for tpose, animtype in pairs(lia.config.DefaultTposingFixer) do
        lia.anim.setModelClass(tpose, animtype)
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------