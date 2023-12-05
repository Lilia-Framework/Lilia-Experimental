﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CreateSalaryTimer(client)
    if not client:getChar() then return end
    local character = client:getChar()
    local timerID = "liaSalary" .. client:SteamID()
    local faction = lia.faction.indices[character:getFaction()]
    local class = lia.class.list[character:getClass()]
    local PayAmount = hook.Run("GetSalaryAmount", client, faction, class) or (class and class.pay) or (faction and faction.pay) or 0
    local SalaryLimit = hook.Run("VerifySalaryLimit", client, faction, class) or (class and class.payLimit) or (faction and faction.playLimit)
    local timerFunc = timer.Exists(timerID) and timer.Adjust or timer.Create
    local delay = (class and class.payTimer) or (faction and faction.payTimer) or lia.config.SalaryInterval
    if PayAmount > 0 then
        timerFunc(
            timerID,
            delay,
            0,
            function()
                if not IsValid(client) or client:getChar() ~= character then
                    timer.Remove(timerID)
                    return
                end

                if SalaryLimit then return end
                character:giveMoney(PayAmount)
                client:notifyLocalized("salary", lia.currency.get(pay))
            end
        )
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLoadedChar(_, _, _)
    for _, client in ipairs(player.GetAll()) do
        hook.Run("CreateSalaryTimer", client)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnReloaded()
    for _, client in ipairs(player.GetAll()) do
        hook.Run("CreateSalaryTimer", client)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetSalaryAmount(client, faction, class)
    if faction.index == FACTION_STAFF then return 0 end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:VerifySalaryLimit(client, _, _)
    if lia.config.SalaryThreshold > 0 and client:getChar():getMoney() >= lia.config.SalaryThreshold then return true end
    return false
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
