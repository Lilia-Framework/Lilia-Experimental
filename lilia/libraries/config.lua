﻿--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config = lia.config or {}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not ConfigWasInitialized then
    lia.config = {
        WalkSpeed = 130, -- How fast characters walk
        RunSpeed = 235, -- How fast characters run
        WalkRatio = 0.5, -- Walk speed ratio when holding Alt
        AllowExistNames = true, -- Allow duplicated character names
        GamemodeName = "A Lilia Gamemode", -- Name of the gamemode
        Color = Color(34, 139, 34), -- Theme color
        Font = "Arial", -- Core font
        GenericFont = "Segoe UI", -- Secondary font
        MoneyModel = "models/props_lab/box01a.mdl", -- Money model
        MaxCharacters = 5, -- Maximum number of characters per player
        DataSaveInterval = 600, -- Time between data saves
        CharacterDataSaveInterval = 300, -- Time between character data saves
        MoneyLimit = 0, -- How much money you can have on yourself | 0 = infinite
        invW = 6, -- Inventory width
        invH = 4, -- Inventory height
        DefaultMoney = 0, -- Default money amount
        MaxChatLength = 256, -- Max Chat Length
        CurrencySymbol = "$", -- Currency symbol
        SpawnTime = 5, -- Time to Repawn
        MaxAttributes = 30, -- Set Maximum Attributes One Can Have
        CurrencySingularName = "Dollar", -- Singular currency name
        CurrencyPluralName = "Dollars", -- Plural currency name
        SchemaYear = 2023, -- Year in the gamemode's schema
        AmericanDates = true, -- Use American date format
        AmericanTimeStamp = true, -- Use American timestamp format
        MinDescLen = 16, -- How long the description has to be
        DatabaseConfig = {
            module = "sqlite", -- Database module
            hostname = "127.0.0.1", -- Database hostname
            username = "", -- Database username
            password = "", -- Database password
            database = "", -- Database name
            port = 3306 -- Database port
        },
        PlayerModelTposingFixer = {} -- Models to fix T-pose issues
    }

    hook.Run("InitializedConfig")
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConfigWasInitialized = true
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
