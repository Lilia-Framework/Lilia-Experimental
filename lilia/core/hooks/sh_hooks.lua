--------------------------------------------------------------------------------------------------------------------------
function GM:EntityEmitSound(data)
    if data.Entity.liaIsMuted then return false end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:OnCharVarChanged(char, varName, oldVar, newVar)
    if lia.char.varHooks[varName] then
        for k, v in pairs(lia.char.varHooks[varName]) do
            v(char, oldVar, newVar)
        end
    end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:Move(client, moveData)
    local char = client:getChar()
    if not char then return end
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
--------------------------------------------------------------------------------------------------------------------------