﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module = lia.module or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.list = lia.module.list or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.unloaded = lia.module.unloaded or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.ModuleFolders = {"dependencies", "/config", "/libs", "/hooks", "/libraries", "/commands", "/netcalls", "/meta", "/derma",}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleConditions = {
    mlogs = mLogs,
    sam = sam,
    ulx = ulx or ULib,
    serverguard = serverguard,
    advdupe2 = AdvDupe2,
    simfphys = simfphys,
    pac = pac
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.load(uniqueID, path, isSingleFile, variable, IsCore)
    local schema = engine.ActiveGamemode()
    variable = uniqueID == "schema" and "SCHEMA" or "MODULE"
    if hook.Run("ModuleShouldLoad", uniqueID) == false then return end
    if not isSingleFile and not file.Exists(path .. "/sh_" .. variable:lower() .. ".lua", "LUA") then return end
    local oldModule = MODULE
    local MODULE = {
        folder = path,
        module = oldModule,
        uniqueID = uniqueID,
        name = "Unknown",
        desc = "Description not available",
        author = "Anonymous",
        identifier = nil,
        IsValid = function(module) return true end
    }

    if uniqueID == "schema" then
        if SCHEMA then MODULE = SCHEMA end
        variable = "SCHEMA"
        MODULE.folder = schema
    elseif lia.module.list[uniqueID] then
        MODULE = lia.module.list[uniqueID]
    end

    _G[variable] = MODULE
    MODULE.loading = true
    MODULE.path = path
    lia.util.include(isSingleFile and path or path .. "/sh_" .. variable:lower() .. ".lua", "shared")
    if MODULE.Dependencies then
        for _, fileName in ipairs(MODULE.Dependencies) do
            lia.util.include(path .. "/" .. fileName)
        end
    end

    if not isSingleFile then lia.module.loadExtras(path) end
    MODULE.loading = false
    local uniqueID2 = uniqueID
    if uniqueID2 == "schema" then uniqueID2 = MODULE.name end
    function MODULE:setData(value, global, ignoreMap)
        lia.data.set(uniqueID2, value, global, ignoreMap)
    end

    function MODULE:getData(default, global, ignoreMap, refresh)
        return lia.data.get(uniqueID2, default, global, ignoreMap, refresh) or {}
    end

    for k, v in pairs(MODULE) do
        if isfunction(v) then hook.Add(k, IsCore and GM or MODULE, v) end
    end
    
    if uniqueID == "schema" then
        function MODULE:IsValid()
            return true
        end
    else
        if MODULE.identifier then
            if _G[MODULE.identifier] then
                print("The identifier '" .. MODULE.identifier .. "' already exists as a global variable.")
            else
                if MODULE.identifier then
                    _G[MODULE.identifier] = MODULE
                    print("Registered" .. MODULE.identifier .. " as global variable pertaining to " .. MODULE.name .. "!")
                end
            end
        end

        lia.module.list[uniqueID] = MODULE
        _G[variable] = oldModule
    end

    hook.Run("ModuleLoaded", uniqueID, MODULE)
    if MODULE.OnLoaded then MODULE:OnLoaded() end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.loadExtras(path)
    for _, folderName in ipairs(lia.config.ModuleFolders) do
        lia.util.includeDir(path .. "/" .. folderName, true, true)
    end

    lia.lang.loadFromDir(path .. "/languages")
    lia.faction.loadFromDir(path .. "/factions")
    lia.class.loadFromDir(path .. "/classes")
    lia.attribs.loadFromDir(path .. "/attributes")
    lia.module.loadFromDir(path .. "/modules")
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
    lia.module.loadFromDir(schema .. "/preload", false)
    lia.module.load("schema", schema .. "/schema", false)
    hook.Run("InitializedSchema")
    lia.module.loadFromDir("lilia/modularity/preload", false)
    lia.module.loadFromDir("lilia/modularity/modules", true)
    lia.module.loadFromDir("lilia/modularity/submodules", false)
    lia.module.loadFromDir(schema .. "/submodules", false)
    lia.module.loadFromDir(schema .. "/modules", false)
    hook.Run("InitializedModules")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.loadFromDir(directory, IsCore)
    local files, folders = file.Find(directory .. "/*", "LUA")
    for k, v in ipairs(folders) do
        lia.module.load(v, directory .. "/" .. v, false, "MODULE", IsCore)
    end

    for k, v in ipairs(files) do
        lia.module.load(string.StripExtension(v), directory .. "/" .. v, true, "MODULE", IsCore)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.setDisabled(uniqueID, disabled)
    disabled = tobool(disabled)
    local oldData = table.Copy(lia.data.get("unloaded", {}, false, true))
    oldData[uniqueID] = disabled
    lia.data.set("unloaded", oldData, false, true, true)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.isDisabled(uniqueID)
    if lia.module.ModuleConditions[uniqueID] ~= nil then return not modules[uniqueID] end
    return lia.config.UnLoadedModules[uniqueID] == true or lia.data.get("unloaded", {}, false, true)[uniqueID] == true
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.get(identifier)
    return lia.module.list[identifier]
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------