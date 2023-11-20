﻿----------------------------------------------------------------------------------------------
DeriveGamemode("sandbox")
----------------------------------------------------------------------------------------------
local FileToSendToClient = {"libraries/config.lua", "libraries/includer.lua", "libraries/loader.lua", "shared.lua",}
----------------------------------------------------------------------------------------------
local FileToInclude = {"shared.lua", "libraries/config.lua", "libraries/includer.lua", "libraries/data.lua", "libraries/databasetables.lua", "libraries/database.lua",}
----------------------------------------------------------------------------------------------
lia = lia or {
    util = {},
    meta = {}
}

----------------------------------------------------------------------------------------------
for _, fileName in ipairs(FileToSendToClient) do
    AddCSLuaFile(fileName)
end

----------------------------------------------------------------------------------------------
for _, fileName in ipairs(FileToInclude) do
    include(fileName)
end

----------------------------------------------------------------------------------------------
timer.Simple(
    0,
    function()
        hook.Run("SetupDatabase")
        lia.db.connect(
            function()
                lia.db.loadTables()
                MsgC(Color(0, 255, 0), "Lilia has connected to the database.\n")
                MsgC(Color(0, 255, 0), "Database Type: " .. lia.db.module .. ".\n")
                hook.Run("DatabaseConnected")
            end
        )
    end
)

----------------------------------------------------------------------------------------------
AddCSLuaFile("libraries/loader.lua")
----------------------------------------------------------------------------------------------
include("libraries/loader.lua")
----------------------------------------------------------------------------------------------
cvars.AddChangeCallback(
    "sbox_persist",
    function(name, old, new)
        timer.Create(
            "sbox_persist_change_timer",
            1,
            1,
            function()
                hook.Run("PersistenceSave", old)
                game.CleanUpMap()
                if new == "" then return end
                hook.Run("PersistenceLoad", new)
            end
        )
    end,
    "sbox_persist_load"
)

----------------------------------------------------------------------------------------------
if game.IsDedicated() then
    concommand.Remove("gm_save")
    concommand.Add("gm_save", function(client, command, arguments) end)
end
----------------------------------------------------------------------------------------------
