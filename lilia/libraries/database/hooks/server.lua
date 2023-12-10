﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local resetCalled = 0
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:RegisterPreparedStatements()
    MsgC(Color(0, 255, 0), "[Lilia] ADDED 5 PREPARED STATEMENTS\n")
    lia.db.prepare("itemData", "UPDATE lia_items SET _data = ? WHERE _itemID = ?", {MYSQLOO_STRING, MYSQLOO_INTEGER})
    lia.db.prepare("itemx", "UPDATE lia_items SET _x = ? WHERE _itemID = ?", {MYSQLOO_INTEGER, MYSQLOO_INTEGER})
    lia.db.prepare("itemy", "UPDATE lia_items SET _y = ? WHERE _itemID = ?", {MYSQLOO_INTEGER, MYSQLOO_INTEGER})
    lia.db.prepare("itemq", "UPDATE lia_items SET _quantity = ? WHERE _itemID = ?", {MYSQLOO_INTEGER, MYSQLOO_INTEGER})
    lia.db.prepare("itemInstance", "INSERT INTO lia_items (_invID, _uniqueID, _data, _x, _y, _quantity) VALUES (?, ?, ?, ?, ?, ?)", {MYSQLOO_INTEGER, MYSQLOO_STRING, MYSQLOO_STRING, MYSQLOO_INTEGER, MYSQLOO_INTEGER, MYSQLOO_INTEGER,})
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:SetupDatabase()
    for k, v in pairs(lia.config.DatabaseConfig) do
        lia.db[k] = v
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:OnMySQLOOConnected()
    hook.Run("RegisterPreparedStatements")
    MYSQLOO_PREPARED = true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:LiliaTablesLoaded()
    local ignore = function() print("") end
    lia.db.query("ALTER TABLE lia_players ADD COLUMN _firstJoin DATETIME"):catch(ignore)
    lia.db.query("ALTER TABLE lia_players ADD COLUMN _lastJoin DATETIME"):catch(ignore)
    lia.db.query("ALTER TABLE lia_items ADD COLUMN _quantity INTEGER"):catch(ignore)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
concommand.Add(
    "lia_recreatedb",
    function(client)
        if not IsValid(client) then
            if resetCalled < RealTime() then
                resetCalled = RealTime() + 3
                MsgC(Color(255, 0, 0), "[Lilia] TO CONFIRM DATABASE RESET, RUN 'lia_recreatedb' AGAIN in 3 SECONDS.\n")
            else
                resetCalled = 0
                MsgC(Color(255, 0, 0), "[Lilia] DATABASE WIPE IN PROGRESS.\n")
                hook.Run("OnWipeTables")
                lia.db.wipeTables(lia.db.loadTables)
            end
        end
    end
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
