﻿--------------------------------------------------------------------------------------------------------------------------
CORE.name = ""
--------------------------------------------------------------------------------------------------------------------------
CORE.author = "76561198312513285"
--------------------------------------------------------------------------------------------------------------------------
CORE.desc = ""
--------------------------------------------------------------------------------------------------------------------------
function GM:ModuleShouldLoad(module)
    return not lia.module.isDisabled(module)
end
--------------------------------------------------------------------------------------------------------------------------
lia.config.ModuleConditions = {
    mlogs = mLogs,
    sam = sam,
    ulx = ulx or ULib,
    serverguard = serverguard,
    simfphys = simfphys,
    pac = pac
}
--------------------------------------------------------------------------------------------------------------------------