﻿----------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    for k, v in pairs(lia.config.SimfphysConsoleCommands) do
        RunConsoleCommand(k, v)
    end
end

----------------------------------------------------------------------------------------------
function MODULE:simfphysPhysicsCollide()
    return true
end
----------------------------------------------------------------------------------------------