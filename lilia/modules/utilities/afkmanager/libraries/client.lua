﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function DrawWarning()
    if AFKKicker.Alpha < 230 then
        AFKKicker.Alpha = AFKKicker.Alpha + (FrameTime() * 200)
    end

    draw.RoundedBox(0, 0, (ScrH() / 2) - ScreenScale(60), ScrW(), ScreenScale(120), Color(0, 0, 0, AFKKicker.Alpha))
    draw.DrawText(AFKKicker.WarningHead, "AFKKicker120", ScrW() * 0.5, (ScrH() * 0.5) - ScreenScale(50), Color(255, 0, 0, AFKKicker.Alpha), TEXT_ALIGN_CENTER)
    draw.DrawText(AFKKicker.WarningSub .. "\nYou will be kicked in " .. math.floor(math.max(AFKKicker.KickTime - (CurTime() - AFKKicker.WarningStart), 0)) .. "s", "AFKKicker25", ScrW() * 0.5, ScrH() * 0.5, Color(255, 255, 255, AFKKicker.Alpha), TEXT_ALIGN_CENTER)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AFKKicker:EnableWarning()
    self.Alpha = 0
    self.WarningStart = CurTime()
    surface.PlaySound("HL1/fvox/bell.wav")
    hook.Add("HUDPaint", "AFKWarning", DrawWarning)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AFKKicker:DisableWarning()
    self.Alpha = nil
    self.AlphaRising = nil
    hook.Remove("HUDPaint", "AFKWarning")
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AFKKicker:LoadFonts()
    surface.CreateFont(
        "AFKKicker25",
        {
            font = "Roboto",
            size = 25,
            weight = 400
        }
    )

    surface.CreateFont(
        "AFKKicker120",
        {
            font = "Roboto",
            size = 120,
            weight = 400
        }
    )
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------