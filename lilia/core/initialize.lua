﻿ModulesLoaded = false
function GM:Initialize()
    lia.module.initialize()
end

function GM:OnReloaded()
    if not ModulesLoaded then
        lia.module.initialize()
        ModulesLoaded = true
    end

    lia.faction.formatModelData()
end
