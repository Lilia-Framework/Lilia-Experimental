------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of entities blocked from physgun move ]]
MODULE.PhysGunMoveRestrictedEntityList = {"prop_dynamic", "func_movelinear", "prop_door_rotating", "lia_vendor"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of entities blocked from the remover tool ]]
MODULE.RemoverBlockedEntities = {"lia_bodygroupcloset", "lia_vendor",}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of entities blocked from the duplicator tool ]]
MODULE.DuplicatorBlackList = {"lia_storage", "lia_money"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of vehicles restricted from general spawn ]]
MODULE.RestrictedVehicles = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of props restricted from general spawn ]]
MODULE.BlackListedProps = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of props restricted from perma propping ]]
MODULE.CanNotPermaProp = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ List of button models to prevent button exploit ]]
MODULE.ButtonList = {"models/maxofs2d/button_01.mdl", "models/maxofs2d/button_02.mdl", "models/maxofs2d/button_03.mdl", "models/maxofs2d/button_04.mdl", "models/maxofs2d/button_05.mdl", "models/maxofs2d/button_06.mdl", "models/maxofs2d/button_slider.mdl"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Makes it so that props frozen can be passed through ]]
MODULE.PassableOnFreeze = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MODULE.CAMIPrivileges = {
    {
        Name = "UserGroups - Staff Group",
        MinAccess = "admin",
        Description = "Defines Player as Staff."
    },
    {
        Name = "UserGroups - VIP Group",
        MinAccess = "superadmin",
        Description = "Defines Player as VIP."
    },
    {
        Name = "Staff Permissions - No Clip Outside Staff Character",
        MinAccess = "superadmin",
        Description = "Allows access to No Clip ESP Outside Staff Character.",
    },
    {
        Name = "Staff Permissions - No Clip ESP Outside Staff Character",
        MinAccess = "superadmin",
        Description = "Allows access to No Clip ESP Outside Staff Character.",
    },
    {
        Name = "Staff Permissions - Can Grab World Props",
        MinAccess = "superadmin",
        Description = "Allows access to grabbing world props."
    },
    {
        Name = "Staff Permissions - Can Grab Players",
        MinAccess = "superadmin",
        Description = "Allows access to grabbing players props."
    },
    {
        Name = "Staff Permissions - Physgun Pickup",
        MinAccess = "admin",
        Description = "Allows access to picking up entities with Physgun."
    },
    {
        Name = "Staff Permissions - Physgun Pickup on Restricted Entities",
        MinAccess = "superadmin",
        Description = "Allows access to picking up restricted entities with Physgun."
    },
    {
        Name = "Staff Permissions - Physgun Pickup on Vehicles",
        MinAccess = "admin",
        Description = "Allows access to picking up Vehicles with Physgun."
    },
    {
        Name = "Staff Permissions - Can't be Grabbed with PhysGun",
        MinAccess = "superadmin",
        Description = "Allows access to not being Grabbed with PhysGun."
    },
    {
        Name = "Staff Permissions - Can Physgun Reload",
        MinAccess = "superadmin",
        Description = "Allows access to Reloading Physgun.",
    },
    {
        Name = "Staff Permissions - Can Property World Entities",
        MinAccess = "superadmin",
        Description = "Allows access to propertying world props."
    },
    {
        Name = "Staff Permissions - Use Entity Properties on Blocked Entities",
        MinAccess = "admin",
        Description = "Allows access to using Entity Properties on Blocked Entities."
    },
    {
        Name = "Staff Permissions - Can Remove Blocked Entities",
        MinAccess = "admin",
        Description = "Allows access to removing blocked entities."
    },
    {
        Name = "Staff Permissions - Can Remove World Entities",
        MinAccess = "superadmin",
        Description = "Allows access to removing world props."
    },
    {
        Name = "Spawn Permissions - Can Spawn Ragdolls",
        MinAccess = "admin",
        Description = "Allows access to spawning ."
    },
    {
        Name = "Spawn Permissions - Can Spawn SWEPs",
        MinAccess = "superadmin",
        Description = "Allows access to spawning SWEPs."
    },
    {
        Name = "Spawn Permissions - Can Spawn Effects",
        MinAccess = "admin",
        Description = "Allows access to spawning Effects."
    },
    {
        Name = "Spawn Permissions - Can Spawn Props",
        MinAccess = "user",
        Description = "Allows access to spawning Props."
    },
    {
        Name = "Spawn Permissions - Can Spawn NPCs",
        MinAccess = "superadmin",
        Description = "Allows access to spawning NPCs."
    },
    {
        Name = "Spawn Permissions - No Car Spawn Delay",
        MinAccess = "superadmin",
        Description = "Allows a user to not have car spawn delay."
    },
    {
        Name = "Spawn Permissions - No Spawn Delay",
        MinAccess = "admin",
        Description = "Allows a user to not have spawn delay."
    },
    {
        Name = "Spawn Permissions - Can Spawn Cars",
        MinAccess = "admin",
        Description = "Allows access to Spawning Cars."
    },
    {
        Name = "Spawn Permissions - Can Spawn Restricted Cars",
        MinAccess = "superadmin",
        Description = "Allows access to Spawning Restricted Cars."
    },
    {
        Name = "Spawn Permissions - Can Spawn SENTs",
        MinAccess = "admin",
        Description = "Allows access to Spawning SENTs."
    },
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
