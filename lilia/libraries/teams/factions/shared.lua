﻿
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.faction = lia.faction or {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.faction.indices = lia.faction.indices or {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.faction.teams = lia.faction.teams or {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.faction.DefaultModels = {"models/humans/group01/male_01.mdl", "models/humans/group01/male_02.mdl", "models/humans/group01/male_04.mdl", "models/humans/group01/male_05.mdl", "models/humans/group01/male_06.mdl", "models/humans/group01/male_07.mdl", "models/humans/group01/male_08.mdl", "models/humans/group01/male_09.mdl", "models/humans/group02/male_01.mdl", "models/humans/group02/male_03.mdl", "models/humans/group02/male_05.mdl", "models/humans/group02/male_07.mdl", "models/humans/group02/male_09.mdl", "models/humans/group01/female_01.mdl", "models/humans/group01/female_02.mdl", "models/humans/group01/female_03.mdl", "models/humans/group01/female_06.mdl", "models/humans/group01/female_07.mdl", "models/humans/group02/female_01.mdl", "models/humans/group02/female_03.mdl", "models/humans/group02/female_06.mdl", "models/humans/group01/female_04.mdl"}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.faction.loadFromDir(directory)
    for _, v in ipairs(file.Find(directory .. "/*.lua", "LUA")) do
        local niceName = v:sub(4, -5)
        FACTION = lia.faction.teams[niceName] or {
            index = table.Count(lia.faction.teams) + 1,
            isDefault = true
        }

        if MODULE then FACTION.module = MODULE.uniqueID end
        lia.util.include(directory .. "/" .. v, "shared")
        if not FACTION.name then
            FACTION.name = "Unknown"
            ErrorNoHalt("Faction '" .. niceName .. "' is missing a name. You need to add a FACTION.name = \"Name\"\n")
        end

        if not FACTION.desc then
            FACTION.desc = "noDesc"
            ErrorNoHalt("Faction '" .. niceName .. "' is missing a description. You need to add a FACTION.desc = \"Description\"\n")
        end

        if not FACTION.color then
            FACTION.color = Color(150, 150, 150)
            ErrorNoHalt("Faction '" .. niceName .. "' is missing a color. You need to add FACTION.color = Color(1, 2, 3)\n")
        end

        team.SetUp(FACTION.index, FACTION.name or "Unknown", FACTION.color or Color(125, 125, 125))
        FACTION.models = FACTION.models or lia.faction.DefaultModels
        FACTION.uniqueID = FACTION.uniqueID or niceName
        for _, modelData in pairs(FACTION.models) do
            if isstring(modelData) then
                util.PrecacheModel(modelData)
            elseif istable(modelData) then
                util.PrecacheModel(modelData[1])
            end
        end

        lia.faction.indices[FACTION.index] = FACTION
        lia.faction.teams[niceName] = FACTION
        FACTION = nil
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.faction.get(identifier)
    return lia.faction.indices[identifier] or lia.faction.teams[identifier]
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.faction.getIndex(uniqueID)
    return lia.faction.teams[uniqueID] and lia.faction.teams[uniqueID].index
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.faction.formatModelData()
    for name, faction in pairs(lia.faction.teams) do
        if faction.models then
            for modelIndex, modelData in pairs(faction.models) do
                local newGroups
                if istable(modelData) and modelData[3] then
                    local groups = {}
                    if istable(modelData[3]) then
                        local dummy
                        if SERVER then
                            dummy = ents.Create("prop_physics")
                            dummy:SetModel(modelData[1])
                        else
                            dummy = ClientsideModel(modelData[1])
                        end

                        local groupData = dummy:GetBodyGroups()
                        for _, group in ipairs(groupData) do
                            if group.id > 0 then
                                if modelData[3][group.id] then
                                    groups[group.id] = modelData[3][group.id]
                                elseif modelData[3][group.name] then
                                    groups[group.id] = modelData[3][group.name]
                                end
                            end
                        end

                        dummy:Remove()
                        newGroups = groups
                    elseif isstring(modelData[3]) then
                        newGroups = string.Explode("", modelData[3])
                    end
                end

                if newGroups then
                    lia.faction.teams[name].models[modelIndex][3] = newGroups
                    lia.faction.indices[faction.index].models[modelIndex][3] = newGroups
                end
            end
        end
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.faction.jobGenerate(index, name, color, default, models)
    local FACTION = {}
    FACTION.index = index
    FACTION.isDefault = default
    FACTION.name = name
    FACTION.desc = ""
    FACTION.color = color
    FACTION.models = models or lia.faction.DefaultModels
    FACTION.uniqueID = name
    for _, v in pairs(FACTION.models) do
        if isstring(v) then
            util.PrecacheModel(v)
        elseif istable(v) then
            util.PrecacheModel(v[1])
        end
    end

    nut.faction.indices[FACTION.index] = FACTION
    nut.faction.teams[name] = FACTION
    team.SetUp(FACTION.index, FACTION.name, FACTION.color)
    return FACTION
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
