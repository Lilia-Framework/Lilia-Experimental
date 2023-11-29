


local function drawBar(x, y, w, h, pos, neg, max, right, label, font, color)
    color = {
        r = color.r + 24,
        g = color.g + 24,
        b = color.b + 24
    }

    if pos > max then
        pos = max
    end

    max = max - 1

    if label then
        if not right then
            surface.SetFont(font)
            surface.SetTextColor(0, 0, 0)
            surface.SetTextPos(x + 1, y - 5)
            surface.DrawText(label)
            surface.SetTextColor(color.r, color.g, color.b)
            surface.SetTextPos(x, y - 6)
            surface.DrawText(label)
            x = x + 40 + 10
        else
            surface.SetFont(font)
            surface.SetTextColor(0, 0, 0)
            surface.SetTextPos(x + w + 13, y - 5)
            surface.DrawText(label)
            surface.SetTextColor(color.r, color.g, color.b)
            surface.SetTextPos(x + w + 12, y - 6)
            surface.DrawText(label)
            x = x - 10
        end
    end

    pos = math.max(((w - 2) / max) * pos, 0)
    neg = math.max(((w - 2) / max) * neg, 0)
    surface.SetDrawColor(0, 0, 0, 150)
    surface.DrawRect(x, y, w + 6, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawOutlinedRect(x, y, w + 6, h)
    surface.SetDrawColor(color.r, color.g, color.b)
    surface.DrawRect(x + 3, y + 3, pos, h - 6)
    surface.SetDrawColor(255, 100, 100)
    surface.DrawRect(x + 4 + (w - neg), y + 3, neg, h - 6)
end

local function drawOutline(x, y, w, h)
    surface.SetDrawColor(0, 0, 0, 150)
    surface.DrawRect(x, y, w + 6, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawOutlinedRect(x, y, w + 6, h)
end

function alaska.hud()
    local localPlayer = LocalPlayer()
    local ply = LocalPlayer()
    local char = ply:getChar()
    local col = lia.config.Color
    local x = ScrW() - 358
    local y = ScrH() - 105
    local w = 105
    local h = 12
    local weapon = localPlayer.GetActiveWeapon(localPlayer)

    if IsValid(weapon) and weapon.DrawAmmo ~= false then
        local clip = weapon.Clip1(weapon)
        local count = localPlayer.GetAmmoCount(localPlayer, weapon.GetPrimaryAmmoType(weapon))
        local secondary = localPlayer.GetAmmoCount(localPlayer, weapon.GetSecondaryAmmoType(weapon))
        local w, h = ScrW(), ScrH()
        local color = lia.config.Color

        if secondary > 0 then
            local x, y = w - 52, h - 128
            draw.SimpleText(secondary, "UI_Medium", x - 29, y - 26, Color(0, 0, 0), 1, 0)
            draw.SimpleText(secondary, "UI_Medium", x - 30, y - 27, color, 1, 0)
        elseif weapon.GetClass(weapon) ~= "weapon_slam" then
            local x, y = w - 52, h - 160
            draw.SimpleText(count, "UI_Medium", x - 29, y + 1, Color(0, 0, 0), 1, 0)
            draw.SimpleText(count, "UI_Medium", x - 30, y, color, 1, 0)
            surface.SetDrawColor(Color(0, 0, 0))
            surface.DrawRect(x - 65, y - 13, 70, 6)
            surface.SetDrawColor(color)
            surface.DrawRect(x - 66, y - 14, 70, 6)
            y = y - 48
            draw.SimpleText(clip, "UI_Medium", x - 29, y + 1, Color(0, 0, 0), 1, 0)
            draw.SimpleText(clip, "UI_Medium", x - 30, y, color, 1, 0)
        end
    end
end

function SCHEMA:HUDPaint()
    local client = LocalPlayer()

    if IsValid(client) and client:Alive() and client:getChar() then
        alaska.hud()

        for i, v in pairs(lia.bars) do
            drawBar(v.x, v.y, v.w, v.h, v.getPos(), v.getNeg(), LocalPlayer():GetMaxHealth() or v.max, v.right, v.label, v.font, v.color)
        end
    end
end

lia.bars["hp"] = {
    w = 256,
    h = 14,
    x = 32,
    y = ScrH() - 46 - 24,
    label = "HP",
    font = "UI_Medium",
    color = Color(86, 152, 248),
    getPos = function()
        return LocalPlayer():Health()
    end,
    getNeg = function()
        return 0
    end,
}

lia.bars["ap"] = {
    right = true,
    w = 256,
    h = 14,
    x = ScrW() - 348,
    y = ScrH() - 46 - 24,
    label = "AP",
    font = "UI_Medium",
    color = lia.config.Color,
    max = 100,
    getPos = function()
        return LocalPlayer():getLocalVar("stm", 0)
    end,
    getNeg = function()
        return 0
    end,
}

function SCHEMA:LoadFonts(font, genericFont)
    surface.CreateFont(
        "UI_Regular",
        {
            font = "roboto-condensed_regular",
            size = 20,
            antialias = true,
            weight = 600,
        }
    )

    surface.CreateFont(
        "UI_Bold",
        {
            font = "roboto-condensed_bold",
            size = 25,
            antialias = true,
            weight = 500,
        }
    )

    surface.CreateFont(
        "UI_Medium",
        {
            font = "roboto-condensed_bold",
            size = 30,
            antialias = true,
            weight = 1000,
        }
    )

    surface.CreateFont(
        "UI_Big",
        {
            font = "roboto-condensed_bold",
            size = 35,
            antialias = true,
            weight = 1000,
        }
    )
end