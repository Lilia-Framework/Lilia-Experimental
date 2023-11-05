function GM:OnPlayerJoinClass(client, class, oldClass)
    local char = client:getChar()
    if char and lia.config.PermaClass then char:setData("pclass", class) end
    local info = lia.class.list[class]
    local info2 = lia.class.list[oldClass]
    if info.onSet then info:onSet(client) end
    if info2 and info2.onLeave then info2:onLeave(client) end
    netstream.Start(nil, "classUpdate", client)
end

function GM:PlayerLoadedChar(client, character, lastChar)
    local data = character:getData("pclass")
    local class = data and lia.class.list[data]
    if class and data then
        local oldClass = character:GetClass()
        if client:Team() == class.faction then
            timer.Simple(
                .3,
                function()
                    character:setClass(class.index)
                    hook.Run("OnPlayerJoinClass", client, class.index, oldClass)
                end
            )
        end
    end

    if character then
        for _, v in pairs(lia.class.list) do
            if (v.faction == client:Team()) and v.isDefault then
                character:setClass(v.index)
                break
            end
        end
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:CheckFactionLimitReached(faction, character, client)
    if isfunction(faction.onCheckLimitReached) then return faction:onCheckLimitReached(character, client) end
    if not isnumber(faction.limit) then return false end
    local maxPlayers = faction.limit
    if faction.limit < 1 then
        maxPlayers = math.Round(#player.GetAll() * faction.limit)
    end

    return team.NumPlayers(faction.index) >= maxPlayers
end

function GM:GetDefaultCharName(client, faction)
    local info = lia.faction.indices[faction]
    if info and info.onGetDefaultName then return info:onGetDefaultName(client) end
end

function GM:GetDefaultCharDesc(client, faction)
    local info = lia.faction.indices[faction]
    if info and info.onGetDefaultDesc then return info:onGetDefaultDesc(client) end
end