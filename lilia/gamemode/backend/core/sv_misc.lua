function GM:GetGameDescription()
    if istable(SCHEMA) then return tostring(SCHEMA.name) end

    return lia.config.DefaultGamemodeName
end

function GM:PlayerSpray(client)
    return true
end

function GM:PlayerDeathSound()
    return true
end

function GM:CanPlayerSuicide(client)
    return false
end

function GM:AllowPlayerPickup(client, entity)
    return false
end

function GM:PlayerShouldTakeDamage(client, attacker)
    return client:getChar() ~= nil
end