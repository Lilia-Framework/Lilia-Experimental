------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module = lia.module or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.list = lia.module.list or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.unloaded = lia.module.unloaded or {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleFolders = {"dependencies", "config", "permissions", "libs", "hooks", "libraries", "commands", "netcalls", "meta", "derma", "pim"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.module.ModuleFiles = {
    ["client.lua"] = "client",
    ["cl_module.lua"] = "client",
    ["sv_module.lua"] = "server",
    ["server.lua"] = "server",
    ["config.lua"] = "shared",
    ["sconfig.lua"] = "server",
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.load(uniqueID, path, isSingleFile, variable)
    local schema = engine.ActiveGamemode()
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
        identifier = nil,
        IsValid = function(_) return true end
    }

    if hook.Run("ModuleShouldLoad", MODULE) == false then return end
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
    lia.util.include(isSingleFile and path or ModuleCore and path .. "/" .. lowerVariable .. ".lua" or ExtendedCore and path .. "/sh_" .. lowerVariable .. ".lua")
    for fileName, state in pairs(lia.module.ModuleFiles) do
        local filePath = path .. "/" .. fileName
        if file.Exists(filePath, "LUA") then lia.util.include(filePath, state) end
    end

    if MODULE.Dependencies then
        for _, fileName in ipairs(MODULE.Dependencies) do
            lia.util.include(path .. "/" .. fileName)
        end
    end

    if MODULE.CAMIPrivileges then
        for _, PrivilegeInfo in pairs(MODULE.CAMIPrivileges) do
            local privilegeData = {
                Name = PrivilegeInfo.Name,
                MinAccess = PrivilegeInfo.MinAccess,
                Description = PrivilegeInfo.Description
            }

            if not CAMI.GetPrivilege(PrivilegeInfo.Name) then CAMI.RegisterPrivilege(privilegeData) end
        end
    end

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
    else
        if MODULE.identifier and MODULE.identifier ~= "" then
            if _G[MODULE.identifier] then
                _G[uniqueID] = MODULE
            else
                _G[MODULE.identifier] = MODULE
            end
        else
            _G[uniqueID] = MODULE
        end

        lia.module.list[uniqueID] = MODULE
        _G[variable] = oldModule
    end

    hook.Run("ModuleLoaded", uniqueID, MODULE)
    if MODULE.OnLoaded then MODULE:OnLoaded() end
    lia.module.loadExtras(path)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.loadExtras(path)
    lia.lang.loadFromDir(path .. "/languages")
    lia.faction.loadFromDir(path .. "/factions")
    lia.class.loadFromDir(path .. "/classes")
    lia.attribs.loadFromDir(path .. "/attributes")
    lia.module.loadFromDir(path .. "/submodules")
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

    for _, folderName in ipairs(lia.module.ModuleFolders) do
        local folderPath = path .. "/" .. folderName
        if file.Exists(folderPath, "LUA") then lia.util.includeDir(folderPath, true, true) end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.module.initialize()
    local schema = engine.ActiveGamemode()
    lia.module.loadFromDir(schema .. "/preload", "schema")
    lia.module.load("schema", schema .. "/schema", false, "schema")
    hook.Run("InitializedSchema")
    lia.module.loadFromDir("lilia/modularity/preloaded")
    lia.module.loadFromDir("lilia/modularity/essentials")
    lia.module.loadFromDir("lilia/modularity/utilities")
    lia.module.loadFromDir(schema .. "/modules")
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
    ["blogs"] = {
        name = "BLogs",
        global = "blogs"
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
