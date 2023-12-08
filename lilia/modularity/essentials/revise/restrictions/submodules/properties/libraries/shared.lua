------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    for name, _ in pairs(properties.List) do
        local privilege = "Staff Permissions - Access Property " .. name:gsub("^%l", string.upper)
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
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------