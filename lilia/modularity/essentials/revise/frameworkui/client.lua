﻿
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Core:HUDPaintBackground()
    if hook.Run("ShouldDrawBranchWarning") then
        hook.Run("BranchWarnin")
    end

    if hook.Run("ShouldDrawEntityInfo") then
        hook.Run("DrawEntityInfo")
    end

    if hook.Run("ShouldDrawBlur") then
        hook.Run("DrawBlur")
    end

    lia.bar.drawAll()
    lia.menu.drawAll()
    self:HUDRegisterEntities()
    self.BaseClass.PaintWorldTips(self.BaseClass)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function FrameworkUICore:HUDPaint()
    if hook.Run("ShouldDrawCrosshair") then
        hook.Run("DrawCrosshair", weapon)
    end

    if hook.Run("ShouldDrawVignette", weapon) then
        hook.Run("DrawAmmo")
    end

    if hook.Run("ShouldDrawAmmo", weapon) then
        hook.Run("DrawAmmo", weapon)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function FrameworkUICore:ShouldHideBars()
    return self.BarsDisabled
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function FrameworkUICore:HUDShouldDraw(element)
    if table.HasValue(self.HiddenHUDElements, element) then return false end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------