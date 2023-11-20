﻿----------------------------------------------------------------------------------------------
lia.currency = lia.currency or {}
----------------------------------------------------------------------------------------------
lia.currency.symbol = lia.currency.symbol or "$"
----------------------------------------------------------------------------------------------
lia.currency.singular = lia.currency.singular or "dollar"
----------------------------------------------------------------------------------------------
lia.currency.plural = lia.currency.plural or "dollars"
----------------------------------------------------------------------------------------------
function lia.currency.set(symbol, singular, plural)
    lia.currency.symbol = symbol
    lia.currency.singular = singular
    lia.currency.plural = plural
end

----------------------------------------------------------------------------------------------
function lia.currency.get(amount)
    return lia.currency.symbol .. (amount == 1 and ("1 " .. lia.currency.singular) or (amount .. " " .. lia.currency.plural))
end

----------------------------------------------------------------------------------------------
function lia.currency.spawn(pos, amount, angle)
    if not pos then
        print("[Lilia] Can't create currency entity: Invalid Position")
    elseif not amount or amount < 0 then
        print("[Lilia] Can't create currency entity: Invalid Amount of money")
    else
        local money = ents.Create("lia_money")
        money:SetPos(pos)
        money:setAmount(math.Round(math.abs(amount)))
        money:SetAngles(angle or Angle(0, 0, 0))
        money:Spawn()
        money:Activate()
        return money
    end
end

----------------------------------------------------------------------------------------------
timer.Simple(1, function() lia.currency.set(lia.config.CurrencySymbol, lia.config.CurrencySingularName, lia.config.CurrencyPluralName) end)
----------------------------------------------------------------------------------------------
