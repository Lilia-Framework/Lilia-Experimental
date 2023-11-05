--------------------------------------------------------------------------------------------------------------------------
lia.config = lia.config or {}
--------------------------------------------------------------------------------------------------------------------------
if not lia.config.WasInitialized then
    lia.config = {
        -- General Gameplay Settings
        EquipDelay = 2, -- Delay OnEquip
        DropDelay = 2, -- Delay OnDrop
        TakeDelay = 2, -- Delay OnTake
        SchemaYear = 2023, -- Year When Schema Happens
        AmericanDates = true, -- American Date Formatting?
        AmericanTimeStamp = true, -- American Time Formatting?
        CarRagdoll = true, -- Enable car ragdolls
        KickOnEnteringMainMenu = true, -- Do you get kicked when going into the Characters Menu?
        TimeUntilDroppedSWEPRemoved = 15, -- Time until dropped weapons are removed (in seconds)
        PlayerSpawnVehicleDelay = 30, -- Delay before players can spawn vehicles (in seconds)
        NPCsDropWeapons = true, -- NPCs drop weapons when killed
        DrawEntityShadows = true, -- Enable entity shadows
        WalkSpeed = 130, -- Player walk speed
        RunSpeed = 235, -- Player run speed
        CharacterSwitchCooldownTimer = 5, -- Cooldown timer for character switching (in seconds)
        CharacterSwitchCooldown = true, -- Enable character switch cooldown
        AutoRegen = false, -- Enable automatic health regeneration
        HealingAmount = 10, -- Amount of health regenerated per tick when AutoRegen is enabled
        HealingTimer = 60, -- Time interval between health regeneration ticks (in seconds)
        PermaClass = true, -- Enable permanent player classes
        -- Cleanup Settings
        ItemCleanupTime = 7200, -- Time interval for cleaning up items on the ground (in seconds)
        MapCleanupTime = 21600, -- Time interval for cleaning up maps (in seconds)
        -- Server Settings
        DevServer = false, -- Is it a Development Server?
        -- Player Interaction Settings
        WalkRatio = 0.5, -- Walk speed ratio (used in certain interactions)
        JumpCooldown = 0.8, -- Cooldown time between jumps (in seconds)
        MaxAttributes = 30, -- Maximum number of player attributes
        AllowExistNames = true, -- Allow existing character names
        -- Communication and Interaction Settings
        FactionBroadcastEnabled = true, -- Enable faction broadcasts
        AdvertisementEnabled = true, -- Enable player advertisements
        AdvertisementPrice = 25, -- Price for player advertisements
        DefaultGamemodeName = "Lilia - Skeleton", -- Default server gamemode name
        -- Visual Settings
        Color = Color(75, 119, 190), -- Default color used for UI elements
        DarkTheme = true, -- Enable dark theme
        Font = "Arial", -- Default font used for UI elements
        GenericFont = "Segoe UI", -- Default generic font used for UI elements
        -- Inventory and Currency Settings
        WhitelistEnabled = false, -- Enable whitelist functionality
        MoneyModel = "models/props_lab/box01a.mdl", -- Model for in-game currency
        AutoWorkshopDownloader = false, -- Automatically download missing workshop content
        MaxCharacters = 5, -- Maximum number of characters per player
        invW = 6, -- Inventory width
        invH = 4, -- Inventory height
        DefaultMoney = 0, -- Default starting amount of in-game currency
        CurrencyPluralName = "Dollars", -- Plural name for in-game currency
        CurrencySingularName = "Dollar", -- Singular name for in-game currency
        CurrencySymbol = "$", -- Currency symbol
        -- Player Attribute Settings
        LoseWeapononDeathNPC = false, -- NPCs do not lose weapons on death
        LoseWeapononDeathHuman = false, -- Players do not lose weapons on death
        LoseWeapononDeathWorld = false, -- Players do not lose weapons on word related deaths
        BranchWarning = true, -- Enable warnings for branching in code
        VersionEnabled = true, -- Enable version tracking
        version = "1.0", -- Server version
        -- Voice and Audio Settings
        AllowVoice = true, -- Enable voice communication
        CharAttrib = {"buttons/button16.wav", 30, 255},
        -- Character attribute settings -- UI and HUD Settings
        ThirdPersonEnabled = true, -- Enable third-person perspective
        CrosshairEnabled = false, -- Enable crosshair
        BarsDisabled = false, -- Disable certain UI bars
        AmmoDrawEnabled = true, -- Enable ammo drawing
        Vignette = true, -- Enable vignette effect
        -- Talk Ranges
        TalkRanges = {
            ["Whispering"] = 120, -- Whispering talk range
            ["Talking"] = 300, -- Normal talking talk range
            ["Yelling"] = 600, -- Yelling talk range
        },
        
        -- Restricted Entity List for PhysGun
        PhysGunMoveRestrictedEntityList = {"prop_door_rotating", "lia_vendor"},
        -- Blocked Entities for Remover Tool
        RemoverBlockedEntities = {"lia_bodygroupcloset", "lia_vendor",},
        -- Blacklisted Entities for Duplicator Tool
        DuplicatorBlackList = {"lia_storage", "lia_money"},
        -- Blocked Collide Entities
        BlockedCollideEntities = {"lia_item", "lia_money"},
        -- Restricted Vehicles
        RestrictedVehicles = {},
        -- Unloaded Modules
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
        
        ServerURLs = {
            ["Discord"] = "https://discord.gg/52MSnh39vw",
            ["Workshop"] = "https://steamcommunity.com/sharedfiles/filedetails/?id=2959728255"
        },
    }
end
--------------------------------------------------------------------------------------------------------------------------
lia.config.WasInitialized = true
--------------------------------------------------------------------------------------------------------------------------
hook.Run("InitializedConfig")
--------------------------------------------------------------------------------------------------------------------------