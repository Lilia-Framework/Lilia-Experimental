----------------------------------------------------------------------------------------------
lia.config = lia.config or {}
----------------------------------------------------------------------------------------------
if not ConfigWasInitialized then
    lia.config = {
        WalkSpeed = 130,
        RunSpeed = 235,
        WalkRatio = 0.5,
        JumpCooldown = 0.8,
        MaxAttributes = 30,
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
        UnLoadedModules = {
            ammosave = false,
            bodygrouper = false,
            chatbox = false,
            cmenu = false,
            corefiles = false,
            crashscreen = false,
            doors = false,
            f1menu = false,
            flashlight = false,
            inventory = false,
            interactionmenu = false,
            mainmenu = false,
            observer = false,
            pac = false,
            permakill = false,
            radio = false,
            raiseweapons = false,
            recognition = false,
            saveitems = false,
            scoreboard = false,
            serverblacklister = false,
            skills = false,
            spawnmenuitems = false,
            spawns = false,
            storage = false,
            tying = false,
            vendor = false,
            weaponselector = false,
            whitelist = false,
        },
    }
end

----------------------------------------------------------------------------------------------
ConfigWasInitialized = true
----------------------------------------------------------------------------------------------
