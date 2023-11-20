﻿----------------------------------------------------------------------------------------------
function lia.util.include(fileName, state)
    if not fileName then error("[Lilia] No file name specified for including.") end
    if (state == "server" or fileName:find("sv_")) and SERVER then
        return include(fileName)
    elseif state == "shared" or fileName:find("sh_") then
        if SERVER then AddCSLuaFile(fileName) end
        return include(fileName)
    elseif state == "client" or fileName:find("cl_") then
        if SERVER then
            AddCSLuaFile(fileName)
        else
            return include(fileName)
        end
    end
end

----------------------------------------------------------------------------------------------
function lia.util.includeDir(directory, fromLua, recursive)
    local baseDir = "lilia"
    if SCHEMA and SCHEMA.folder and SCHEMA.loading then
        baseDir = SCHEMA.folder .. "/schema/"
    else
        baseDir = baseDir .. "/gamemode/"
    end

    if recursive then
        local function AddRecursive(folder, baseFolder)
            local files, folders = file.Find(folder .. "/*", "LUA")
            if not files then
                MsgN("Warning! This folder is empty!")
                return
            end

            for k, v in pairs(files) do
                local fullPath = folder .. "/" .. v
                lia.util.include(fullPath)
            end

            for k, v in pairs(folders) do
                local subFolder = baseFolder .. "/" .. v
                AddRecursive(folder .. "/" .. v, subFolder)
            end
        end

        local initialFolder = (fromLua and "" or baseDir) .. directory
        AddRecursive(initialFolder, initialFolder)
    else
        for k, v in ipairs(file.Find((fromLua and "" or baseDir) .. directory .. "/*.lua", "LUA")) do
            local fullPath = directory .. "/" .. v
            lia.util.include(fullPath)
        end
    end
end
----------------------------------------------------------------------------------------------
