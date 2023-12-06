----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config = lia.config or {}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not ConfigWasInitialized then
    lia.config = {
        WalkSpeed = 130, -- How fast characters walk
        RunSpeed = 235, -- How fast characters run
        WalkRatio = 0.5, -- Walk speed ratio when holding Alt
        AllowExistNames = true, -- Allow duplicated character names
        GamemodeName = "A Lilia Gamemode", -- Name of the gamemode
        Color = Color(75, 119, 190), -- Theme color
        Font = "Arial", -- Core font
        GenericFont = "Segoe UI", -- Secondary font
        MoneyModel = "models/props_lab/box01a.mdl", -- Money model
        MaxCharacters = 5, -- Maximum number of characters per player
        DataSaveInterval = 600, -- Time between data saves
        invW = 6, -- Inventory width
        invH = 4, -- Inventory height
        DefaultMoney = 0, -- Default money amount
        CurrencySymbol = "$", -- Currency symbol
        CurrencySingularName = "Dollar", -- Singular currency name
        CurrencyPluralName = "Dollars", -- Plural currency name
        SchemaYear = 2023, -- Year in the gamemode's schema
        AmericanDates = true, -- Use American date format
        AmericanTimeStamp = true, -- Use American timestamp format
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

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConfigWasInitialized = true
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
