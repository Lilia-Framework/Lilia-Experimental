﻿
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local useCheapBlur = CreateClientConVar("lia_cheapblur", 0, true):GetBool()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.drawText(text, x, y, color, alignX, alignY, font, alpha)
    color = color or color_white
    return     draw.TextShadow(
        {
            text = text,
            font = font or "liaGenericFont",
            pos = {x, y},
            color = color,
            xalign = alignX or 0,
            yalign = alignY or 0
        },
        1,
        alpha or (color.a * 0.575)
    )
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.notifQuery(question, option1, option2, manualDismiss, notifType, callback)
    if not callback or not isfunction(callback) then Error("A callback function must be specified") end
    if not question or not isstring(question) then Error("A question string must be specified") end
    if not option1 then option1 = "Yes" end
    if not option2 then option2 = "No" end
    if not manualDismiss then manualDismiss = false end
    local notice = CreateNoticePanel(10, manualDismiss)
    local i = table.insert(lia.noticess, notice)
    notice.isQuery = true
    notice.text:SetText(question)
    notice:SetPos(0, (i - 1) * (notice:GetTall() + 4) + 4)
    notice:SetTall(36 * 2.3)
    notice:CalcWidth(120)
    notice:CenterHorizontal()
    notice.notifType = notifType or 7
    if manualDismiss then notice.start = nil end
    notice.opt1 = notice:Add("DButton")
    notice.opt1:SetAlpha(0)
    notice.opt2 = notice:Add("DButton")
    notice.opt2:SetAlpha(0)
    notice.oh = notice:GetTall()
    OrganizeNotices()
    notice:SetTall(0)
    notice:SizeTo(
        notice:GetWide(),
        36 * 2.3,
        0.2,
        0,
        -1,
        function()
            notice.text:SetPos(0, 0)
            local function styleOpt(o)
                o.color = Color(0, 0, 0, 30)
                AccessorFunc(o, "color", "Color")
                function o:Paint(w, h)
                    if self.left then
                        draw.RoundedBoxEx(4, 0, 0, w + 2, h, self.color, false, false, true, false)
                    else
                        draw.RoundedBoxEx(4, 0, 0, w + 2, h, self.color, false, false, false, true)
                    end
                end
            end

            if notice.opt1 and IsValid(notice.opt1) then
                notice.opt1:SetAlpha(255)
                notice.opt1:SetSize(notice:GetWide() / 2, 25)
                notice.opt1:SetText(option1 .. " (F8)")
                notice.opt1:SetPos(0, notice:GetTall() - notice.opt1:GetTall())
                notice.opt1:CenterHorizontal(0.25)
                notice.opt1:SetAlpha(0)
                notice.opt1:AlphaTo(255, 0.2)
                notice.opt1:SetTextColor(color_white)
                notice.opt1.left = true
                styleOpt(notice.opt1)
                function notice.opt1:keyThink()
                    if input.IsKeyDown(KEY_F8) and (CurTime() - notice.lastKey) >= 0.5 then
                        self:ColorTo(Color(24, 215, 37), 0.2, 0)
                        notice.respondToKeys = false
                        callback(1, notice)
                        timer.Simple(1, function() if notice and IsValid(notice) then RemoveNotice(notice) end end)
                        notice.lastKey = CurTime()
                    end
                end
            end

            if notice.opt2 and IsValid(notice.opt2) then
                notice.opt2:SetAlpha(255)
                notice.opt2:SetSize(notice:GetWide() / 2, 25)
                notice.opt2:SetText(option2 .. " (F9)")
                notice.opt2:SetPos(0, notice:GetTall() - notice.opt2:GetTall())
                notice.opt2:CenterHorizontal(0.75)
                notice.opt2:SetAlpha(0)
                notice.opt2:AlphaTo(255, 0.2)
                notice.opt2:SetTextColor(color_white)
                styleOpt(notice.opt2)
                function notice.opt2:keyThink()
                    if input.IsKeyDown(KEY_F9) and (CurTime() - notice.lastKey) >= 0.5 then
                        self:ColorTo(Color(24, 215, 37), 0.2, 0)
                        notice.respondToKeys = false
                        callback(2, notice)
                        timer.Simple(1, function() if notice and IsValid(notice) then RemoveNotice(notice) end end)
                        notice.lastKey = CurTime()
                    end
                end
            end

            notice.lastKey = CurTime()
            notice.respondToKeys = true
            function notice:Think()
                if not self.respondToKeys then return end
                local queries = {}
                for _, v in pairs(lia.noticess) do
                    if v.isQuery then queries[#queries + 1] = v end
                end

                for _, v in pairs(queries) do
                    if v == self and k > 1 then return end
                end

                if self.opt1 and IsValid(self.opt1) then self.opt1:keyThink() end
                if self.opt2 and IsValid(self.opt2) then self.opt2:keyThink() end
            end
        end
    )
    return notice
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.wrapText(text, width, font)
    font = font or "liaChatFont"
    surface.SetFont(font)
    local exploded = string.Explode("%s", text, true)
    local line = ""
    local lines = {}
    local w = surface.GetTextSize(text)
    local maxW = 0
    if w <= width then
        text, _ = text:gsub("%s", " ")
        return {text}, w
    end

    for i = 1, #exploded do
        local word = exploded[i]
        line = line .. " " .. word
        w = surface.GetTextSize(line)
        if w > width then
            lines[#lines + 1] = line
            line = ""
            if w > maxW then maxW = w end
        end
    end

    if line ~= "" then lines[#lines + 1] = line end
    return lines, maxW
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.notify(message)
    chat.AddText(message)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.notifyLocalized(message, ...)
    lia.util.notify(L(message, ...))
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.drawBlur(panel, amount, passes)
    amount = amount or 5
    if useCheapBlur then
        surface.SetDrawColor(50, 50, 50, amount * 20)
        surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
    else
        surface.SetMaterial(lia.util.getMaterial("pp/blurscreen"))
        surface.SetDrawColor(255, 255, 255)
        local x, y = panel:LocalToScreen(0, 0)
        for i = -(passes or 0.2), 1, 0.2 do
            lia.util.getMaterial("pp/blurscreen"):SetFloat("$blur", i * amount)
            lia.util.getMaterial("pp/blurscreen"):Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
        end
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.getInjuredColor(client)
    local health_color = color_white
    if not IsValid(client) then return health_color end
    local health, healthMax = client:Health(), client:GetMaxHealth()
    if (health / healthMax) < .95 then health_color = lia.color.LerpHSV(nil, nil, healthMax, health, 0) end
    return health_color
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.ScreenScaleH(n, type)
    if type then
        if ScrH() > 720 then return n end
        return math.ceil(n / 1080 * ScrH())
    end
    return n * (ScrH() / 480)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Derma_NumericRequest(strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText)
    local Window = vgui.Create("DFrame")
    Window:SetTitle(strTitle or "Message Title (First Parameter)")
    Window:SetDraggable(false)
    Window:ShowCloseButton(false)
    Window:SetBackgroundBlur(true)
    Window:SetDrawOnTop(true)
    local InnerPanel = vgui.Create("DPanel", Window)
    InnerPanel:SetPaintBackground(false)
    local Text = vgui.Create("DLabel", InnerPanel)
    Text:SetText(strText or "Message Text (Second Parameter)")
    Text:SizeToContents()
    Text:SetContentAlignment(5)
    Text:SetTextColor(color_white)
    local TextEntry = vgui.Create("DTextEntry", InnerPanel)
    TextEntry:SetValue(strDefaultText or "")
    TextEntry.OnEnter = function()
        Window:Close()
        fnEnter(TextEntry:GetValue())
    end

    TextEntry:SetNumeric(true)
    local ButtonPanel = vgui.Create("DPanel", Window)
    ButtonPanel:SetTall(30)
    ButtonPanel:SetPaintBackground(false)
    local Button = vgui.Create("DButton", ButtonPanel)
    Button:SetText(strButtonText or "OK")
    Button:SizeToContents()
    Button:SetTall(20)
    Button:SetWide(Button:GetWide() + 20)
    Button:SetPos(5, 5)
    Button.DoClick = function()
        Window:Close()
        fnEnter(TextEntry:GetValue())
    end

    local ButtonCancel = vgui.Create("DButton", ButtonPanel)
    ButtonCancel:SetText(strButtonCancelText or L"derma_request_cancel")
    ButtonCancel:SizeToContents()
    ButtonCancel:SetTall(20)
    ButtonCancel:SetWide(Button:GetWide() + 20)
    ButtonCancel:SetPos(5, 5)
    ButtonCancel.DoClick = function()
        Window:Close()
        if fnCancel then fnCancel(TextEntry:GetValue()) end
    end

    ButtonCancel:MoveRightOf(Button, 5)
    ButtonPanel:SetWide(Button:GetWide() + 5 + ButtonCancel:GetWide() + 10)
    local w, h = Text:GetSize()
    w = math.max(w, 400)
    Window:SetSize(w + 50, h + 25 + 75 + 10)
    Window:Center()
    InnerPanel:StretchToParent(5, 25, 5, 45)
    Text:StretchToParent(5, 5, 5, 35)
    TextEntry:StretchToParent(5, nil, 5, nil)
    TextEntry:AlignBottom(5)
    TextEntry:RequestFocus()
    TextEntry:SelectAllText(true)
    ButtonPanel:CenterHorizontal()
    ButtonPanel:AlignBottom(8)
    Window:MakePopup()
    Window:DoModal()
    return Window
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
file.CreateDir("lilia/images")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.util.LoadedImages = lia.util.LoadedImages or {
    [0] = Material("icon16/cross.png")
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function lia.util.FetchImage(id, callback, failImg, pngParameters, imageProvider)
    failImg = failImg
    local loadedImage = lia.util.LoadedImages[id]
    if loadedImage then
        if callback then callback(loadedImage) end
        return
    end

    if file.Exists("lilia/images/" .. id .. ".png", "DATA") then
        local mat = Material("data/lilia/images/" .. id .. ".png", pngParameters or "noclamp smooth")
        if mat then
            lia.util.LoadedImages[id] = mat
            if callback then callback(mat) end
        elseif callback then
            callback(false)
        end
    else
        http.Fetch(
            (imageProvider or "https://i.imgur.com/") .. id .. ".png",
            function(body, size, headers, code)
                if code ~= 200 then
                    callback(false)
                    return
                end

                if not body or body == "" then
                    callback(false)
                    return
                end

                file.Write("lilia/images/" .. id .. ".png", body)
                local mat = Material("data/lilia/images/" .. id .. ".png", "noclamp smooth")
                lia.util.LoadedImages[id] = mat
                if callback then callback(mat) end
            end,
            function() if callback then callback(false) end end
        )
    end
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
cvars.AddChangeCallback("lia_cheapblur", function(name, old, new) useCheapBlur = (tonumber(new) or 0) > 0 end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
