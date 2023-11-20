﻿----------------------------------------------------------------------------------------------
local loop, nicoSeats, nicoEnabled
----------------------------------------------------------------------------------------------
local vjThink = 0
----------------------------------------------------------------------------------------------
function MODULE:ServersideInitializedModules()
    for _, timerName in pairs(lia.config.ServerTimersToRemove) do
        timer.Remove(timerName)
    end

    for k, v in pairs(lia.config.ServerStartupConsoleCommand) do
        RunConsoleCommand(k, v)
    end

    for k, v in pairs(ents.GetAll()) do
        if lia.config.EntitiesToBeRemoved[v:GetClass()] then
            v:Remove()
        end
    end
end

----------------------------------------------------------------------------------------------
function MODULE:Think()
    if VJ and vjThink <= CurTime() then
        for k, v in pairs(lia.config.VJBaseConsoleCommands) do
            RunConsoleCommand(k, v)
        end

        vjThink = CurTime() + 180
    end

    if not nicoSeats or not nicoSeats[loop] then
        loop = 1
        nicoSeats = {}
        for _, seat in ipairs(ents.FindByClass("prop_vehicle_prisoner_pod")) do
            if seat.nicoSeat then
                table.insert(nicoSeats, seat)
            end
        end
    end

    while nicoSeats[loop] and not IsValid(nicoSeats[loop]) do
        loop = loop + 1
    end

    local seat = nicoSeats[loop]
    if nicoEnabled ~= seat and IsValid(nicoEnabled) then
        local saved = nicoEnabled:GetSaveTable()
        if not saved["m_bEnterAnimOn"] and not saved["m_bExitAnimOn"] then
            nicoEnabled:AddEFlags(EFL_NO_THINK_FUNCTION)
            nicoEnabled = nil
        end
    end

    if IsValid(seat) then
        seat:RemoveEFlags(EFL_NO_THINK_FUNCTION)
        nicoEnabled = seat
    end

    loop = loop + 1
end

----------------------------------------------------------------------------------------------
function MODULE:PlayerEnteredVehicle(client, vehicle)
    if IsValid(vehicle) and vehicle.nicoSeat then
        table.insert(nicoSeats, loop, vehicle)
    end
end

----------------------------------------------------------------------------------------------
function MODULE:PlayerLeaveVehicle(client, vehicle)
    if IsValid(vehicle) and vehicle.nicoSeat then
        table.insert(nicoSeats, loop, vehicle)
    end
end

----------------------------------------------------------------------------------------------
function MODULE:PropBreak(attacker, ent)
    if ent:IsValid() and ent:GetPhysicsObject():IsValid() then
        constraint.RemoveAll(ent)
    end
end

----------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(client)
    local annoying = ents.FindByName("music")
    local val = ents.GetMapCreatedEntity(1733)
    if #annoying > 0 then
        annoying[1]:SetKeyValue("RefireTime", 99999999)
        annoying[1]:Fire("Disable")
        annoying[1]:Fire("Kill")
        val:SetKeyValue("RefireTime", 99999999)
        val:Fire("Disable")
        val:Fire("Kill")
    end

    self:RegisterPlayer(client)
end
----------------------------------------------------------------------------------------------