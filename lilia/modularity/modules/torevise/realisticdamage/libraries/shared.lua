﻿
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetPlayerDeathSound(_, isFemale)
    local soundTable
    soundTable = isFemale and lia.config.FemaleDeathSounds or lia.config.MaleDeathSounds
    return soundTable and soundTable[math.random(#soundTable)]
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetPlayerPainSound(_, paintype, isFemale)
    local soundTable
    if paintype == "drown" then
        soundTable = isFemale and lia.config.FemaleDrownSounds or lia.config.MaleDrownSounds
    elseif paintype == "hurt" then
        soundTable = isFemale and lia.config.FemaleHurtSounds or lia.config.MaleHurtSounds
    end
    return soundTable and soundTable[math.random(#soundTable)]
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:GetFallDamage(_, speed)
    return math.max(0, (speed - 580) * (100 / 444))
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
