----------------------------------------------------------------------------------------------
function MODULE:LoadFonts(font)
    surface.CreateFont(
        "WB_Small",
        {
            font = "Product Sans",
            size = 17
        }
    )

    surface.CreateFont(
        "WB_Medium",
        {
            font = "Product Sans",
            size = 20
        }
    )

    surface.CreateFont(
        "WB_Large",
        {
            font = "Product Sans",
            size = 24,
            weight = 800
        }
    )

    surface.CreateFont(
        "WB_XLarge",
        {
            font = "Product Sans",
            size = 35,
            weight = 800
        }
    )

    surface.CreateFont(
        "WB_Enormous",
        {
            font = "Product Sans",
            size = 54
        }
    )
end

----------------------------------------------------------------------------------------------
function WB:ColorBrighten(col)
    return Color(col.r + 10, col.g + 10, col.b + 10, col.a)
end

----------------------------------------------------------------------------------------------
function WB:StyleButton(pnl, hoverCol, idleCol, roundCorners, smoothHover)
    AccessorFunc(pnl, "color", "Color")
    pnl:SetColor(idleCol)
    if smoothHover or false then
        function pnl:OnCursorEntered()
            self:ColorTo(hoverCol, 0.2, 0)
        end

        function pnl:OnCursorExited()
            self:ColorTo(idleCol, 0.2, 0)
        end
    end

    function pnl:Paint(w, h)
        draw.RoundedBox(roundCorners, 0, 0, w, h, self:GetColor())
    end
end

----------------------------------------------------------------------------------------------
function draw.Circle(x, y, radius, seg)
    local cir = {}
    table.insert(
        cir,
        {
            x = x,
            y = y,
            u = 0.5,
            v = 0.5
        }
    )

    for i = 0, seg do
        local a = math.rad((i / seg) * -360)
        table.insert(
            cir,
            {
                x = x + math.sin(a) * radius,
                y = y + math.cos(a) * radius,
                u = math.sin(a) / 2 + 0.5,
                v = math.cos(a) / 2 + 0.5
            }
        )
    end

    local a = math.rad(0)
    table.insert(
        cir,
        {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius,
            u = math.sin(a) / 2 + 0.5,
            v = math.cos(a) / 2 + 0.5
        }
    )

    surface.DrawPoly(cir)
end

----------------------------------------------------------------------------------------------
function CreateOverBlur(callback)
    local blur = vgui.Create("DPanel")
    blur:SetSize(ScrW(), ScrH())
    blur:Center()
    blur:MakePopup()
    blur:SetAlpha(0)
    blur:AlphaTo(
        255,
        0.15,
        0,
        function()
            if callback then
                callback(blur)
            end
        end
    )

    function blur:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 150))
        lia.util.drawBlur(self, 6)
    end

    function blur:Think()
        if self:HasFocus() then
            local c = self:GetChildren()
            if #c > 0 then
                c[1]:MakePopup()
            end
        end
    end

    function blur:OnKeyCodePressed(key)
        if key == KEY_F1 then
            self:Remove()
        end
    end

    function blur:SmoothClose()
        self:AlphaTo(
            0,
            0.2,
            0.15,
            function()
                self:Remove()
            end
        )
    end

    return blur
end

----------------------------------------------------------------------------------------------
function follow(pnl1, pnl2, side)
    side = side or BOTTOM
    if side == BOTTOM then
        local p2x, p2y = pnl2:GetPos()
        pnl1:SetPos(p2x, p2y + pnl2:GetTall() + 10)
    elseif side == LEFT then
        pnl1:SetPos(pnl2:GetX() - pnl1:GetWide() - 5, pnl1:GetY() - pnl1:GetTall() / 4)
    elseif side == RIGHT then
        pnl1:SetPos(pnl2:GetX() + pnl2:GetWide(), pnl2:GetY() - pnl1:GetTall() / 4)
    end
end
----------------------------------------------------------------------------------------------