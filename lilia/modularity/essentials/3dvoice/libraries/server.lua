﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
    local IsVoiceEnabled = self.IsVoiceEnabled and GetGlobalBool("EnabledVoice", true)
    local IsVoiceBanned = speaker:getChar():getData("VoiceBan", false)
    local VoiceRefreshRate = self.VoiceRefreshRate
    local VoiceType = speaker:getNetVar("VoiceType", "Talking")
    local VoiceRadius = self.TalkRanges[VoiceType]
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
            if self.IsVoicePropBlockingEnabled then
                if not tr.Hit or table.HasValue(self.WhitelistedProps, tr.Entity:GetModel()) then
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
function VoiceCore:PostPlayerLoadout(client)
    client:setNetVar("VoiceType", "Talking")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
