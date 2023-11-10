--------------------------------------------------------------------------------------------------------------------------
lia.config = lia.config or {}
--------------------------------------------------------------------------------------------------------------------------
if not lia.config.WasInitialized then
    lia.config = {
        WalkSpeed = 130,
        RunSpeed = 235,
        WalkRatio = 0.5,
        JumpCooldown = 0.8,
        MaxAttributes = 30,
        AllowExistNames = true,
        DefaultGamemodeName = "Lilia - Skeleton",
        Color = Color(75, 119, 190),
        DarkTheme = true,
        Font = "Arial",
        GenericFont = "Segoe UI",
        MoneyModel = "models/props_lab/box01a.mdl",
        MaxCharacters = 5,
        invW = 6,
        invH = 4,
        DefaultMoney = 0,
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

--------------------------------------------------------------------------------------------------------------------------
lia.config.WasInitialized = true
--------------------------------------------------------------------------------------------------------------------------
hook.Run("InitializedConfig")
--------------------------------------------------------------------------------------------------------------------------
