----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mLogs.addCategory("Lilia", "lia", Color(121, 65, 203), function() return true end, nil, 105)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mLogs.addCategoryDefinitions(
    "lia",
    {
        chat = function(data) return mLogs.doLogReplace({"[", "^chatType", "]", "^client", ":", "^msg"}, data) end,
        command = function(data) return mLogs.doLogReplace({"^client", "tried to run command", "^command"}, data) end,
        charLoad = function(data) return mLogs.doLogReplace({"^client", "loaded the character", "^char"}, data) end,
        charDelete = function(data) return mLogs.doLogReplace({"^client", "deleted the character", "^char"}, data) end,
        itemUse = function(data) return mLogs.doLogReplace({"^client", "tried", "^action", "to item", "^item"}, data) end,
        vendor = function(data) return mLogs.doLogReplace({"^client", data.selling and "sold item" or "bought item", "^item", data.selling and "to vendor" or "from vendor", "^vendor", "for", "^price"}, data) end,
    }
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
