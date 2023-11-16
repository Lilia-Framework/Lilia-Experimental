--------------------------------------------------------------------------------------------------------------------------
lia.core = lia.core or {}
--------------------------------------------------------------------------------------------------------------------------
lia.module = lia.module or {}
--------------------------------------------------------------------------------------------------------------------------
lia.core.list = lia.core.list or {}
--------------------------------------------------------------------------------------------------------------------------
lia.module.list = lia.module.list or {}
--------------------------------------------------------------------------------------------------------------------------
lia.module.unloaded = lia.module.unloaded or {}
--------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleConditions = {
    mlogs = mLogs,
    sam = sam,
    ulx = ulx or ULib,
    serverguard = serverguard,
    simfphys = simfphys,
    pac = pac
}
--------------------------------------------------------------------------------------------------------------------------
function lia.module.load(uniqueID, path, isSingleFile, variable)
    variable = uniqueID == "schema" and "SCHEMA" or (uniqueID == "core" and "CORE" or "MODULE")
    if uniqueID ~= "core" and hook.Run("ModuleShouldLoad", uniqueID) == false then return end
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
        MODULE.folder = engine.ActiveGamemode()
    elseif uniqueID == "core" then
        if CORE then MODULE = CORE end
        variable = "CORE"
        MODULE = lia.core.list[uniqueID]
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
        if isfunction(v) then hook.Add(k, MODULE, v) end
    end

    if uniqueID == "schema" then
        function MODULE:IsValid()
            return true
        end
    elseif uniqueID == "core" then
        lia.core.list[uniqueID] = MODULE
        _G[variable] = oldModule
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

--------------------------------------------------------------------------------------------------------------------------
function lia.module.loadExtras(path)
    lia.lang.loadFromDir(path .. "/languages")
    lia.faction.loadFromDir(path .. "/factions")
    lia.class.loadFromDir(path .. "/classes")
    lia.attribs.loadFromDir(path .. "/attributes")
    lia.util.includeDir(path .. "/config", true, true)
    lia.util.includeDir(path .. "/libs", true, true)
    lia.util.includeDir(path .. "/hooks", true)
    lia.util.includeDir(path .. "/libraries", true, true)
    lia.util.includeDir(path .. "/commands", true, true)
    lia.util.includeDir(path .. "/netcalls", true, true)
    lia.util.includeDir(path .. "/meta", true, true)
    lia.util.includeDir(path .. "/derma", true)
    lia.module.loadFromDir(path .. "/modules")
    lia.module.loadEntities(path .. "/entities")
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

--------------------------------------------------------------------------------------------------------------------------
function lia.module.loadEntities(path)
    local files, folders
    local function IncludeFiles(path2, clientOnly)
        if (SERVER and file.Exists(path2 .. "init.lua", "LUA")) or (CLIENT and file.Exists(path2 .. "cl_init.lua", "LUA")) then
            lia.util.include(path2 .. "init.lua", clientOnly and "client" or "server")
            if file.Exists(path2 .. "cl_init.lua", "LUA") then lia.util.include(path2 .. "cl_init.lua", "client") end
            return true
        elseif file.Exists(path2 .. "shared.lua", "LUA") then
            lia.util.include(path2 .. "shared.lua", "shared")
            return true
        end
        return false
    end

    local function HandleEntityInclusion(folder, variable, register, default, clientOnly)
        files, folders = file.Find(path .. "/" .. folder .. "/*", "LUA")
        default = default or {}
        for k, v in ipairs(folders) do
            local path2 = path .. "/" .. folder .. "/" .. v .. "/"
            _G[variable] = table.Copy(default)
            _G[variable].ClassName = v
            if IncludeFiles(path2, clientOnly) and not client then
                if clientOnly then
                    if CLIENT then register(_G[variable], v) end
                else
                    register(_G[variable], v)
                end
            end

            _G[variable] = nil
        end

        for k, v in ipairs(files) do
            local niceName = string.StripExtension(v)
            _G[variable] = table.Copy(default)
            _G[variable].ClassName = niceName
            lia.util.include(path .. "/" .. folder .. "/" .. v, clientOnly and "client" or "shared")
            if clientOnly then
                if CLIENT then register(_G[variable], niceName) end
            else
                register(_G[variable], niceName)
            end

            _G[variable] = nil
        end
    end

    HandleEntityInclusion(
        "entities",
        "ENT",
        scripted_ents.Register,
        {
            Type = "anim",
            Base = "base_gmodentity",
            Spawnable = true
        }
    )

    HandleEntityInclusion(
        "weapons",
        "SWEP",
        weapons.Register,
        {
            Primary = {},
            Secondary = {},
            Base = "weapon_base"
        }
    )

    HandleEntityInclusion("effects", "EFFECT", effects and effects.Register, nil, true)
end

--------------------------------------------------------------------------------------------------------------------------
function lia.module.initialize()
    lia.lang.loadFromDir(path .. "/dependencies")
    lia.item.loadFromDir("lilia/core/items")
    lia.lang.loadFromDir("lilia/core/languages")
    lia.module.loadEntities("lilia/core/entities")
    lia.util.includeDir("lilia/core/commands", true, true)
    lia.module.loadFromDir(engine.ActiveGamemode() .. "/preload")
    lia.module.load("schema", engine.ActiveGamemode() .. "/schema")
    hook.Run("InitializedSchema")
    lia.module.loadFromDir("lilia/modules")
    lia.module.loadFromDir(engine.ActiveGamemode() .. "/modules")
    hook.Run("InitializedConfig")
    hook.Run("InitializedItems")
    hook.Run("InitializedModules")
end

--------------------------------------------------------------------------------------------------------------------------
function lia.module.loadFromDir(directory)
    local files, folders = file.Find(directory .. "/*", "LUA")
    for k, v in ipairs(folders) do
        lia.module.load(v, directory .. "/" .. v)
    end

    for k, v in ipairs(files) do
        lia.module.load(string.StripExtension(v), directory .. "/" .. v, true)
    end
end

--------------------------------------------------------------------------------------------------------------------------
function lia.module.setDisabled(uniqueID, disabled)
    disabled = tobool(disabled)
    local oldData = table.Copy(lia.data.get("unloaded", {}, false, true))
    oldData[uniqueID] = disabled
    lia.data.set("unloaded", oldData, false, true, true)
end

--------------------------------------------------------------------------------------------------------------------------
function lia.module.isDisabled(uniqueID)
    if lia.module.ModuleConditions[uniqueID] ~= nil then return not modules[uniqueID] end
    return lia.config.UnLoadedModules[uniqueID] == true or lia.data.get("unloaded", {}, false, true)[uniqueID] == true
end

--------------------------------------------------------------------------------------------------------------------------
function lia.module.get(identifier)
    return lia.module.list[identifier]
end
--------------------------------------------------------------------------------------------------------------------------