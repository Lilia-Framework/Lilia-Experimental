﻿----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CheckPassword(steamID64)
    if table.HasValue(lia.config.BlacklistedSteamID64, steamID64) then return false, "You are blacklisted from this server!" end
    if lia.config.WhitelistEnabled and not table.HasValue(lia.config.WhitelistedSteamID64, steamID64) then return false, "Sorry, you are not whitelisted for " .. GetHostName() end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------