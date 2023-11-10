﻿--------------------------------------------------------------------------------------------------------------------------
local MODULE = MODULE
--------------------------------------------------------------------------------------------------------------------------
function group()
    local g = {}
    function g:FadeOutRem(callback, fullRem)
        fullRem = fullRem or false
        for k, v in pairs(self:GetChildren()) do
            v:AlphaTo(
                0,
                0.2,
                0,
                function()
                    v:Hide()
                    if fullRem then
                        v:Remove()
                    end
                end
            )
        end

        if callback then
            timer.Simple(0.2, callback)
        end
    end

    function g:FadeIn(delay)
        delay = delay or 0
        for k, v in pairs(self:GetChildren()) do
            if not v.Show then continue end
            v:Show()
            v:SetAlpha(0)
            v:AlphaTo(255, 0.2, delay)
        end
    end

    function g:FadeOut(callback, time)
        time = time or 0.2
        for k, v in pairs(self:GetChildren()) do
            v:AlphaTo(0, time)
            v:Hide()
        end

        if callback then
            timer.Simple(time, callback)
        end
    end

    function g:GetChildren()
        local c = {}
        for k, v in pairs(self) do
            if isfunction(v) then continue end
            c[#c + 1] = v
        end

        return c
    end

    function g:AddChildren(panel)
        for _, pnl in pairs(panel:GetChildren()) do
            table.insert(g, pnl)
        end
    end

    return g
end

--------------------------------------------------------------------------------------------------------------------------
function getHovCol(col)
    if not col then return end

    return Color(col.r + 10, col.g + 10, col.b + 10, col.a)
end

--------------------------------------------------------------------------------------------------------------------------
function DebugPanel(pnl)
    function pnl:Paint(w, h)
        surface.SetDrawColor(255, 0, 0)
        surface.DrawRect(0, 0, w, h)
    end
end

--------------------------------------------------------------------------------------------------------------------------
function strPosAngConv(str)
    local pos = str:Split(";")[1]:Split("setpos")[2]:Split(" ")
    pos = Vector(pos[2], pos[3], pos[4])
    local ang = str:Split(";")[2]:Split("setang")[2]:Split(" ")
    ang = Angle(ang[2], ang[3], ang[4])

    return pos, ang
end

--------------------------------------------------------------------------------------------------------------------------
MODULE.drawTextEntry = function(panel, w, h)
    local color = Color(235, 235, 235)
    if panel:IsEditing() then
        color = color_white
    else
        color = Color(235, 235, 235)
    end

    draw.RoundedBox(4, 0, 0, w, h, color)
    panel:DrawTextEntryText(color_black, Color(75, 75, 235), color_black)
end
--------------------------------------------------------------------------------------------------------------------------