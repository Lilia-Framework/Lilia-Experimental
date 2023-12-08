------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local GM = GM or GAMEMODE
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local VoiceData = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VoiceData.cache = CurTime()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VoiceData.CanHearCache = false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function GM:PlayerCanHearPlayersVoice(listener, speaker)
    local HasCharacter = speaker:getChar()
    if not HasCharacter then return false end
    local IsVoiceEnabled = MODULEoiceEnabled and GetGlobalBool("EnabledVoice", true)
    local IsVoiceBanned = speaker:getChar():getData("VoiceBan", false)
    local VoiceRefreshRate = MODULEceRefreshRate
    local VoiceType = speaker:getNetVar("VoiceType", "Talking")
    local VoiceRadius = MODULEkRanges[VoiceType]
    local VoiceRadiusSquared = VoiceRadius * VoiceRadius
    local tr = util.TraceLine(
        {
            start = speaker:EyePos(),
            endpos = listener:EyePos(),
            filter = player.GetAll()
        }
    )

    if not IsVoiceEnabled or IsVoiceBanned then return false end
    if (CurTime() - VoiceData.cache > VoiceRefreshRate) and (listener ~= speaker) then
        VoiceData.cache = CurTime()
        if speaker:GetPos():DistToSqr(listener:GetPos()) <= VoiceRadiusSquared then
            if MODULEoicePropBlockingEnabled then
                if not tr.Hit or table.HasValue(MODULEtelistedProps, tr.Entity:GetModel()) then
                    VoiceData.CanHearCache = true
                else
                    VoiceData.CanHearCache = false
                end
            else
                VoiceData.CanHearCache = true
            end
        end
    end

    if VoiceData.CanHearCache then
        return true, true
    else
        return false, false
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PostPlayerLoadout(client)
    client:setNetVar("VoiceType", "Talking")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------