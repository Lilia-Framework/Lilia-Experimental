------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MODULE.ConsoleRun = MODULE.ConsoleRun or concommand.Run
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function net.Incoming(len, client)
    local i = net.ReadHeader()
    local name = util.NetworkIDToString(i)
    if not name and IsValid(client) then
        ServerLog(string.format("Unpooled message name for net msg #%d Client: %s (STEAMID: %s) \n", i, client:Nick(), client:SteamID()))

        return
    elseif not name then
        return
    end

    local func = net.Receivers[name:lower()]
    if not func and IsValid(client) then
        ServerLog(string.format("No receiving function for '%s' (net msg #%d) Client: %s (STEAMID: %s) \n", name, i, client:Nick(), client:SteamID()))

        return
    elseif not func then
        return
    end

    len = len - 16
    if not table.HasValue(MODULE.ExploitableNetMessages, name) then
        if IsValid(client) and (client.LastMSG or 0) < CurTime() - 0.25 then
            ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) \n", name, i, len / 8 / 1024, len / 8, client:Nick(), client:SteamID()))
            client.LastMSG = CurTime()
        elseif (client.LastMSG or 0) < CurTime() - 0.25 then
            ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) \n", name, i, len / 8 / 1024, len / 8, "UNKNOWN", "UNKNOWN"))
        end
    else
        if IsValid(client) and (client.LastMSG or 0) < CurTime() - 0.25 then
            ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) [ Exploitable String ] \n", name, i, len / 8 / 1024, len / 8, client:Nick(), client:SteamID()))
            client.LastMSG = CurTime()
        elseif (client.LastMSG or 0) < CurTime() - 0.25 then
            ServerLog(string.format("Net message '%s' (%d) received (%.2fkb (%db)) Client: %s (STEAMID: %s) [ Exploitable String ] \n", name, i, len / 8 / 1024, len / 8, "UNKNOWN", "UNKNOWN"))
        end
    end

    status, error = pcall(
        function()
            func(len, client)
        end
    )

    if not status then
        ServerLog(string.format("Error during net message (%s). Reasoning: %s \n", name, error))
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function concommand.Run(client, cmd, args)
    if not IsValid(client) then return MODULE.ConsoleRun(client, cmd, args) end
    if not cmd then return MODULE.ConsoleRun(client, cmd, args) end
    if args and args ~= "" and #args ~= 0 then
        ServerLog(client:Name() .. "( " .. client:SteamID() .. " )" .. "has executed this command: " .. cmd .. " " .. table.concat(args, " ") .. ". \n")
    else
        ServerLog(client:Name() .. "( " .. client:SteamID() .. " )" .. " has executed this command: " .. cmd .. ". \n")
    end

    return MODULE.ConsoleRun(client, cmd, args)
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------