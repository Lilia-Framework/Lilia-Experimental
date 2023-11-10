--------------------------------------------------------------------------------------------------------------------------
local VoiceData = {}
--------------------------------------------------------------------------------------------------------------------------
VoiceData.cache = CurTime()
--------------------------------------------------------------------------------------------------------------------------
VoiceData.CanHearCache = false
--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerCanHearPlayersVoice(listener, speaker)
    local HasCharacter = speaker:getChar()
    local IsVoiceEnabled = lia.config.IsVoiceEnabled
    local IsVoiceBanned = speaker:getChar():getData("VoiceBan", false)
    local VoiceRefreshRate = lia.config.VoiceRefreshRate
    local VoiceType = speaker:getNetVar("VoiceType", "Talking")
    local VoiceRadius = lia.config.TalkRanges[VoiceType]
    local VoiceRadiusSquared = VoiceRadius * VoiceRadius
    local tr = util.TraceLine(
        {
            start = speaker:EyePos(),
            endpos = listener:EyePos(),
            filter = player.GetAll()
        }
    )

    if not (HasCharacter or IsVoiceEnabled) or IsVoiceBanned then return false end
    if (CurTime() - VoiceData.cache > VoiceRefreshRate) and (listener ~= speaker) then
        VoiceData.cache = CurTime()
        if speaker:GetPos():DistToSqr(listener:GetPos()) <= VoiceRadiusSquared then
            if lia.config.IsVoicePropBlockingEnabled then
                if not tr.Hit or table.HasValue(lia.config.WhitelistedProps, tr.Entity:GetModel()) then
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

--------------------------------------------------------------------------------------------------------------------------
function GM:PostPlayerLoadout(client)
    client:setNetVar("VoiceType", "Talking")
end
--------------------------------------------------------------------------------------------------------------------------
