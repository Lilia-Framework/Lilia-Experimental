hook.Run("ShouldAllowScoreboardOverride", client, "name") 
hook.Run("GetDisplayedName", client)
hook.Run("GetDisplayedDescription", client)
hook.Run("ShouldDeleteSavedItems")
hook.Run("InitializedSchema")
hook.Run("InitializedConfig")
hook.Run("InitializedItems")
hook.Run("ModuleShouldLoad", uniqueID)
hook.Run("ModuleLoaded", uniqueID, MODULE)
hook.Run("DoModuleIncludes", path, MODULE)
hook.Run("CharacterFlagCheck", self, flags)
hook.Run("CreateSalaryTimer", client)
hook.Run("CanDeleteChar", client, char)
hook.Run("FactionOnLoadout", client)
hook.Run("ClassOnLoadout", client)
hook.Run("OnItemSpawned", ent)
hook.Run("CanPlayerInteractItem", client, action, item)
hook.Run("CanPlayerEquipItem", client, item)
hook.Run("CanPlayerTakeItem", client, item)
hook.Run("CanPlayerDropItem", client, item)