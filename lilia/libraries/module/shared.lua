﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module = lia.module or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.list = lia.module.list or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.unloaded = lia.module.unloaded or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleFolders = {"derma", "netcalls", "meta",}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.load(uniqueID, path, isSingleFile, variable)
    local lowerVariable = variable:lower()
    local ModuleCore = file.Exists(path .. "/" .. lowerVariable .. ".lua", "LUA")
    local ExtendedCore = file.Exists(path .. "/sh_" .. lowerVariable .. ".lua", "LUA")
    if not isSingleFile and not ModuleCore and not ExtendedCore then return end
    local oldModule = MODULE
    MODULE = {
        folder = path,
        module = oldModule,
        uniqueID = uniqueID,
        name = "Unknown",
        desc = "Description not available",
        author = "Anonymous",
        IsValid = function(_) return true end
    }

    if uniqueID == "schema" then
        if SCHEMA then
            MODULE = SCHEMA
        end

        variable = "SCHEMA"
        MODULE.folder = engine.ActiveGamemode()
    elseif lia.module.list[uniqueID] then
        MODULE = lia.module.list[uniqueID]
    end

    _G[variable] = MODULE
    MODULE.loading = true
    MODULE.path = path
    lia.util.include(isSingleFile and path or ModuleCore and path .. "/" .. lowerVariable .. ".lua" or ExtendedCore and path .. "/sh_" .. lowerVariable .. ".lua")
    MODULE.loading = false
    local uniqueID2 = uniqueID
    if uniqueID2 == "schema" then
        uniqueID2 = MODULE.name
    end

    function MODULE:setData(value, global, ignoreMap)
        lia.data.set(uniqueID2, value, global, ignoreMap)
    end

    function MODULE:getData(default, global, ignoreMap, refresh)
        return lia.data.get(uniqueID2, default, global, ignoreMap, refresh) or {}
    end

    for k, v in pairs(MODULE) do
        if isfunction(v) then
            hook.Add(k, MODULE, v)
        end
    end

    if uniqueID == "schema" then
        function MODULE:IsValid()
            return true
        end
    else
        local shouldNotLoad, reason = hook.Run("ModuleShouldNotLoad", MODULE)
        if shouldNotLoad then
            if reason then
                print(reason)
            end

            return
        end

        lia.module.list[uniqueID] = MODULE
        _G[variable] = oldModule
    end

    lia.module.loadExtras(path)
    hook.Run("ModuleLoaded", uniqueID, MODULE)
    if MODULE.OnLoaded then
        MODULE:OnLoaded()
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.loadExtras(path)
    local libraryFolder = path .. "/libraries"
    local subLibraryFolder = path .. "/libraries/libs"
    local configFolder = path .. "/config"
    if file.Exists(configFolder, "LUA") then
        lia.util.includeDir(configFolder, true, true)
    end

    if file.Exists(libraryFolder, "LUA") then
        lia.util.includeDir(libraryFolder, true, false)
    end

    if file.Exists(subLibraryFolder, "LUA") then
        lia.util.includeDir(subLibraryFolder, true, true)
    end

    for _, folder in ipairs(lia.module.ModuleFolders) do
        local subFolders = path .. "/" .. folder
        if file.Exists(subFolders, "LUA") then
            lia.util.includeDir(subFolders, true, true)
        end
    end

    lia.module.loadFromDir(path .. "/submodules", "module")
    lia.lang.loadFromDir(path .. "/languages")
    lia.faction.loadFromDir(path .. "/factions")
    lia.class.loadFromDir(path .. "/classes")
    lia.attribs.loadFromDir(path .. "/attributes")
    lia.util.loadEntities(path .. "/entities")
    hook.Run("DoModuleIncludes", path, MODULE)
    hook.Add(
        "InitializedModules",
        "liaItems" .. path,
        function()
            lia.item.loadFromDir(path .. "/items")
            hook.Remove("InitializedModules", "liaItems" .. path)
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.initialize()
    local schema = engine.ActiveGamemode()
    lia.module.loadFromDir(schema .. "/preload", "schema")
    lia.module.load("schema", schema .. "/schema", false, "schema")
    hook.Run("InitializedSchema")
    lia.module.loadFromDir("lilia/modularity/preloaded", "module")
    lia.module.loadFromDir("lilia/modularity/essentials", "module")
    lia.module.loadFromDir("lilia/modularity/utilities", "module")
    lia.module.loadFromDir(schema .. "/modules", "module")
    hook.Run("InitializedModules")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.loadFromDir(directory, group)
    local location = group == "schema" and "SCHEMA" or "MODULE"
    local files, folders = file.Find(directory .. "/*", "LUA")
    for _, v in ipairs(folders) do
        lia.module.load(v, directory .. "/" .. v, false, location)
    end

    for _, v in ipairs(files) do
        lia.module.load(string.StripExtension(v), directory .. "/" .. v, true, location)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.get(identifier)
    return lia.module.list[identifier]
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleConditions = {
    ["permaprops"] = {
        name = "PermaProps",
        global = "PermaProps"
    },
    ["vjbase"] = {
        name = "VJ Base",
        global = "VJ"
    },
    ["mlogs"] = {
        name = "mLogs",
        global = "mLogs"
    },
    ["sam"] = {
        name = "SAM Admin Mod",
        global = "sam"
    },
    ["ulx"] = {
        name = "ULX Admin Mod",
        global = "ulx"
    },
    ["serverguard"] = {
        name = "ServerGuard Admin Mod",
        global = "serverguard"
    },
    ["advdupe2"] = {
        name = "Advanced Dupe 2",
        global = "AdvDupe2"
    },
    ["advdupe"] = {
        name = "Advanced Dupe 1",
        global = "AdvDupe"
    },
    ["zmc"] = {
        name = "Zero's MasterChef",
        global = "zmc"
    },
    ["zpf"] = {
        name = "Zero's Factory",
        global = "zpf"
    },
    ["sitanywhere"] = {
        name = "The Sit Anywhere Script",
        global = "SitAnywhere"
    },
    ["simfphys"] = {
        name = "Simfphys LUA Vehicles Base",
        global = "simfphys"
    },
    ["pac"] = {
        name = "Player Appearance Customizer 3 (PAC3)",
        global = "pac"
    }
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------