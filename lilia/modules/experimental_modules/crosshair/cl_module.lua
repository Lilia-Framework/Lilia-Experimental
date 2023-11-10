﻿--------------------------------------------------------------------------------------------------------------------------
local function drawdot(pos, size, col)
    pos[1] = math.Round(pos[1])
    pos[2] = math.Round(pos[2])
    draw.RoundedBox(0, pos[1] - size / 2, pos[2] - size / 2, size, size, col[1])
    size = size - 2
    draw.RoundedBox(0, pos[1] - size / 2, pos[2] - size / 2, size, size, col[2])
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:HUDPaint()
    if not hook.Run("ShouldDrawCrosshair") then return end
    local client = LocalPlayer()
    local t = util.QuickTrace(client:GetShootPos(), client:GetAimVector() * 15000, client)
    local pos = t.HitPos:ToScreen()
    local col = {color_white, color_white}
    drawdot({pos.x, pos.y}, 3, col)
end

--------------------------------------------------------------------------------------------------------------------------
function MODULE:ShouldDrawCrosshair()
    local client = LocalPlayer()
    local entity = Entity(client:getLocalVar("ragdoll", 0))
    if not lia.config.CrosshairEnabled then return false end
    if not IsValid(client) or not client:Alive() or not client:getChar() or IsValid(entity) or (g_ContextMenu:IsVisible() or IsValid(lia.gui.character) and lia.gui.character:IsVisible()) then return false end
    local wep = client:GetActiveWeapon()
    if wep and IsValid(wep) then
        local className = wep:GetClass()
        if className == "gmod_tool" or string.find(className, "lia_") or string.find(className, "detector_") then return true end
        if lia.config.NoDrawCrosshairWeapon[wep:GetClass()] then return false end
        return true
    end
end
--------------------------------------------------------------------------------------------------------------------------
