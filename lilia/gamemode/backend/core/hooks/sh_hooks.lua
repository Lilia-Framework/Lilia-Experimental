local vectorAngle = FindMetaTable("Vector").Angle
local normalizeAngle = math.NormalizeAngle
local oldCalcSeqOverride
lia.anim.DefaultTposingFixer = {
    ["models/police.mdl"] = "metrocop",
    ["models/combine_super_soldier.mdl"] = "overwatch",
    ["models/combine_soldier_prisonGuard.mdl"] = "overwatch",
    ["models/combine_soldier.mdl"] = "overwatch",
    ["models/vortigaunt.mdl"] = "vort",
    ["models/vortigaunt_blue.mdl"] = "vort",
    ["models/vortigaunt_doctor.mdl"] = "vort",
    ["models/vortigaunt_slave.mdl"] = "vort",
    ["models/alyx.mdl"] = "citizen_female",
    ["models/mossman.mdl"] = "citizen_female",
}

HOLDTYPE_TRANSLATOR = HOLDTYPE_TRANSLATOR or {}
HOLDTYPE_TRANSLATOR[""] = "normal"
HOLDTYPE_TRANSLATOR["physgun"] = "smg"
HOLDTYPE_TRANSLATOR["ar2"] = "smg"
HOLDTYPE_TRANSLATOR["crossbow"] = "shotgun"
HOLDTYPE_TRANSLATOR["rpg"] = "shotgun"
HOLDTYPE_TRANSLATOR["slam"] = "normal"
HOLDTYPE_TRANSLATOR["grenade"] = "grenade"
HOLDTYPE_TRANSLATOR["melee2"] = "melee"
HOLDTYPE_TRANSLATOR["passive"] = "smg"
HOLDTYPE_TRANSLATOR["knife"] = "melee"
HOLDTYPE_TRANSLATOR["duel"] = "pistol"
HOLDTYPE_TRANSLATOR["camera"] = "smg"
HOLDTYPE_TRANSLATOR["magic"] = "normal"
HOLDTYPE_TRANSLATOR["revolver"] = "pistol"
PLAYER_HOLDTYPE_TRANSLATOR = PLAYER_HOLDTYPE_TRANSLATOR or {}
PLAYER_HOLDTYPE_TRANSLATOR[""] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["normal"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["revolver"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["fist"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["pistol"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["grenade"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["slam"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["melee2"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["knife"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["duel"] = "normal"
PLAYER_HOLDTYPE_TRANSLATOR["bugbait"] = "normal"
function GM:InitializedConfig()
    if CLIENT then
        self:ClientInitializedConfig()
    end

    for tpose, animtype in pairs(lia.anim.DefaultTposingFixer) do
        lia.anim.setModelClass(tpose, animtype)
    end
end



function GM:TranslateActivity(client, act)
    local model = string.lower(client.GetModel(client))
    local class = lia.anim.getModelClass(model) or "player"
    local weapon = client.GetActiveWeapon(client)
    if class == "player" then
        if not lia.config.WepAlwaysRaised and IsValid(weapon) and (client.isWepRaised and not client.isWepRaised(client)) and client:OnGround() then
            if string.find(model, "zombie") then
                local tree = lia.anim.zombie
                if string.find(model, "fast") then
                    tree = lia.anim.fastZombie
                end

                if tree[act] then return tree[act] end
            end

            local holdType = IsValid(weapon) and (weapon.HoldType or weapon.GetHoldType(weapon)) or "normal"
            holdType = PLAYER_HOLDTYPE_TRANSLATOR[holdType] or "passive"
            local tree = lia.anim.player[holdType]
            if tree and tree[act] then
                if type(tree[act]) == "string" then
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

                if type(act) == "string" then
                    client.CalcSeqOverride = client.LookupSequence(client, act)

                    return
                else
                    return act
                end
            else
                act = tree.normal[ACT_MP_CROUCH_IDLE][1]
                if type(act) == "string" then
                    client.CalcSeqOverride = client:LookupSequence(act)
                end

                return
            end
        elseif client.OnGround(client) then
            client.ManipulateBonePosition(client, 0, vector_origin)
            if IsValid(weapon) then
                subClass = weapon.HoldType or weapon.GetHoldType(weapon)
                subClass = HOLDTYPE_TRANSLATOR[subClass] or subClass
            end

            if tree[subClass] and tree[subClass][act] then
                local index = (not client.isWepRaised or client:isWepRaised()) and 2 or 1
                local act2 = tree[subClass][act][index]
                if type(act2) == "string" then
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

function GM:DoAnimationEvent(client, event, data)
    local class = lia.anim.getModelClass(client:GetModel())
    if class == "player" then
        return self.BaseClass:DoAnimationEvent(client, event, data)
    else
        local weapon = client:GetActiveWeapon()
        if IsValid(weapon) then
            local holdType = weapon.HoldType or weapon:GetHoldType()
            holdType = HOLDTYPE_TRANSLATOR[holdType] or holdType
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

function GM:EntityEmitSound(data)
    if data.Entity.liaIsMuted then return false end
end

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

function GM:CalcMainActivity(client, velocity)
    client.CalcIdeal = ACT_MP_STAND_IDLE
    oldCalcSeqOverride = client.CalcSeqOverride
    client.CalcSeqOverride = -1
    local animClass = lia.anim.getModelClass(client:GetModel())
    if animClass ~= "player" then
        client:SetPoseParameter("move_yaw", normalizeAngle(vectorAngle(velocity)[2] - client:EyeAngles()[2]))
    end

    if not (self:HandlePlayerLanding(client, velocity, client.m_bWasOnGround) or self:HandlePlayerNoClipping(client, velocity) or self:HandlePlayerDriving(client) or self:HandlePlayerVaulting(client, velocity) or (usingPlayerAnims and self:HandlePlayerJumping(client, velocity)) or self:HandlePlayerSwimming(client, velocity) or self:HandlePlayerDucking(client, velocity)) then
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

function GM:OnCharVarChanged(char, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for k, v in pairs(lia.char.varHooks[varName]) do
            v(char, oldVar, newVar)
        end
    end
end





function GM:Move(client, moveData)
    local char = client:getChar()
    if char then
        if client:getNetVar("actAng") then
            moveData:SetForwardSpeed(0)
            moveData:SetSideSpeed(0)
        end

        if client:GetMoveType() == MOVETYPE_WALK and moveData:KeyDown(IN_WALK) then
            local mf, ms = 0, 0
            local speed = client:GetWalkSpeed()
            local ratio = lia.config.WalkRatio
            if moveData:KeyDown(IN_FORWARD) then
                mf = ratio
            elseif moveData:KeyDown(IN_BACK) then
                mf = -ratio
            end

            if moveData:KeyDown(IN_MOVELEFT) then
                ms = -ratio
            elseif moveData:KeyDown(IN_MOVERIGHT) then
                ms = ratio
            end

            moveData:SetForwardSpeed(mf * speed)
            moveData:SetSideSpeed(ms * speed)
        end
    end
end

function GM:CanItemBeTransfered(item, curInv, inventory)
    if item.isBag and curInv ~= inventory and item.getInv and item:getInv() and table.Count(item:getInv():getItems()) > 0 then
        local char = lia.char.loaded[curInv.owner]
        if SERVER and char and char:getPlayer() then
            char:getPlayer():notify("You can't transfer a backpack that has items inside of it.")
        elseif CLIENT then
            lia.util.notify("You can't transfer a backpack that has items inside of it.")
        end

        return false
    end

    if item.onCanBeTransfered then
        local itemHook = item:onCanBeTransfered(curInv, inventory)

        return itemHook ~= false
    end
end

function GM:InitializedModules()
    if SERVER then
        if lia.config.MapCleanerEnabled then
            self:CallMapCleanerInit()
        end

        self:InitalizedWorkshopDownloader()
        self:InitializedExtrasServer()
    else
        self:InitializedExtrasClient()
    end

    self:RegisterCamiPermissions()
    self:InitializedExtrasShared()
    timer.Simple(
        2,
        function()
            self:TPosingModelsFix()
        end
    )
end

function GM:TPosingModelsFix()
    for _, model in pairs(lia.config.PlayerModelTposingFixer) do
        lia.anim.setModelClass(model, "player")
    end
end

function GM:InitPostEntity()
    if CLIENT then
        if IsValid(g_VoicePanelList) then
            g_VoicePanelList:Remove()
        end

        g_VoicePanelList = vgui.Create("DPanel")
        g_VoicePanelList:ParentToHUD()
        g_VoicePanelList:SetSize(270, ScrH() - 200)
        g_VoicePanelList:SetPos(ScrW() - 320, 100)
        g_VoicePanelList:SetPaintBackground(false)
        self:ClientPostInit()
    else
        self:ServerPostInit()
    end
end

function GM:InitializedExtrasShared()
    

    if StormFox2 then
        for k, v in pairs(lia.config.StormFox2ConsoleCommands) do
            RunConsoleCommand(k, v)
        end
    end

    if ArcCW then
        for k, v in pairs(lia.config.ArcCWConsoleCommands) do
            RunConsoleCommand(k, v)
        end
    end

    if TFA then
        for k, v in pairs(lia.config.TFAConsoleCommands) do
            RunConsoleCommand(k, v)
        end
    end

    for hookType, identifiers in pairs(lia.config.RemovableHooks) do
        for _, identifier in ipairs(identifiers) do
            hook.Remove(hookType, identifier)
        end
    end
end



function GM:PSALoader()
    local TalkModesPSAString = "Please Remove Talk Modes. Our framework has such built in by default."
    local ULXPSAString = [[
            /*
            
            PUBLIC SERVICE ANNOUNCEMENT FOR LILIA SERVER OWNERS
            
            There is a ENOURMOUS performance issue with ULX Admin mod.
            Lilia Development Team found ULX is the main issue
            that make the server freeze when player count is higher
            than 20-30. The duration of freeze will be increased as you get
            more players on your server.
            
            If you're planning to open big server with ULX/ULib, Lilia
            Development Team does not recommend your plan. Server Performance
            Issues with ULX/Ulib on your server will be ignored and we're
            going to consider that you're taking the risk of ULX/Ulib's
            critical performance issue.
            
            Lilia 1.2 only displays this message when you have ULX or
            ULib on your server.
            
                                           -Lilia Development Team
            
            */]]
    if ulx or ULib then
        MsgC(Color(255, 0, 0), ULXPSAString .. "\n")
    end

    if TalkModes then
        timer.Simple(
            2,
            function()
                MsgC(Color(255, 0, 0), TalkModesPSAString)
            end
        )
    end
end

function GM:IsValidTarget(target)
    return IsValid(target) and target:IsPlayer() and target:getChar()
end