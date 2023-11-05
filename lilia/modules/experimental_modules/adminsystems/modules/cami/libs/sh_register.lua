--------------------------------------------------------------------------------------------------------------------------
function GM:InitializedModules()
    for _, PrivilegeInfo in pairs(lia.config.CAMIPrivileges) do
        local privilegeData = {
            Name = PrivilegeInfo.Name,
            MinAccess = PrivilegeInfo.MinAccess,
            Description = PrivilegeInfo.Description
        }

        if not CAMI.GetPrivilege(PrivilegeInfo.Name) then
            CAMI.RegisterPrivilege(privilegeData)
        end
    end

    for _, wep in pairs(weapons.GetList()) do
        if wep.ClassName == "gmod_tool" then
            for ToolName, TOOL in pairs(wep.Tool) do
                if not ToolName then continue end
                local privilege = "Lilia - Staff Permissions - Access Tool " .. ToolName:gsub("^%l", string.upper)
                if not CAMI.GetPrivilege(privilege) then
                    local privilegeInfo = {
                        Name = privilege,
                        MinAccess = "admin",
                        Description = "Allows access to " .. ToolName:gsub("^%l", string.upper)
                    }

                    CAMI.RegisterPrivilege(privilegeInfo)
                end
            end
        end
    end

    for name, _ in pairs(properties.List) do
        local privilege = "Lilia - Staff Permissions - Access Property " .. name:gsub("^%l", string.upper)
        if not CAMI.GetPrivilege(privilege) then
            local privilegeInfo = {
                Name = privilege,
                MinAccess = "admin",
                Description = "Allows access to Entity Property " .. name:gsub("^%l", string.upper)
            }

            CAMI.RegisterPrivilege(privilegeInfo)
        end
    end
end
--------------------------------------------------------------------------------------------------------------------------