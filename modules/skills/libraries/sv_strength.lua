----------------------------------------------------------------------------------------------
function MODULE:PlayerGetFistDamage(client, damage, context)
    local char = client:getChar()
    local strbonus = hook.Run("GetPunchStrengthBonusDamage", char)
    if client:getChar() then context.damage = context.damage + strbonus end
end
----------------------------------------------------------------------------------------------
