﻿local vignetteAlphaGoal = 0
local vignetteAlphaDelta = 0
local hasVignetteMaterial = lia.util.getMaterial("lilia/gui/vignette.png") ~= "___error"
function MODULE:HUDPaintBackground()
    if not lia.config.Vignette then return end
    if not hasVignetteMaterial then return end
    local frameTime = FrameTime()
    local scrW, scrH = ScrW(), ScrH()
    vignetteAlphaDelta = math.Approach(vignetteAlphaDelta, vignetteAlphaGoal, frameTime * 30)
    surface.SetDrawColor(0, 0, 0, 175 + vignetteAlphaDelta)
    surface.SetMaterial(lia.util.getMaterial("lilia/gui/vignette.png"))
    surface.DrawTexturedRect(0, 0, scrW, scrH)
end

timer.Create(
    "liaVignetteChecker",
    1,
    0,
    function()
        local client = LocalPlayer()
        if IsValid(client) then
            local data = {}
            data.start = client:GetPos()
            data.endpos = data.start + Vector(0, 0, 768)
            data.filter = client
            local trace = util.TraceLine(data)
            if trace and trace.Hit then
                vignetteAlphaGoal = 80
            else
                vignetteAlphaGoal = 0
            end
        end
    end
)
