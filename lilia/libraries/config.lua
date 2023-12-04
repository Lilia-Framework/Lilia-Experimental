----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config = lia.config or {}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if not ConfigWasInitialized then
    lia.config = {
        WalkSpeed = 130,
        RunSpeed = 235,
        WalkRatio = 0.5,
        AllowExistNames = true,
        GamemodeName = "A Lilia Gamemode",
        Color = Color(75, 119, 190),
        Font = "Arial",
        GenericFont = "Segoe UI",
        MoneyModel = "models/props_lab/box01a.mdl",
        MaxCharacters = 5,
        DataSaveInterval = 600,
        invW = 6,
        invH = 4,
        DefaultMoney = 0,
        CurrencySymbol = "$",
        CurrencySingularName = "Dollar",
        CurrencyPluralName = "Dollars",
        SchemaYear = 2023,
        AmericanDates = true,
        AmericanTimeStamp = true,
        DatabaseConfig = {
            module = "sqlite",
            hostname = "127.0.0.1",
            username = "",
            password = "",
            database = "",
            port = 3306
        },
        UnLoadedModules = {},
        PlayerModelTposingFixer = {},
    }
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ConfigWasInitialized = true
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
hook.Run("InitializedConfig")
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
