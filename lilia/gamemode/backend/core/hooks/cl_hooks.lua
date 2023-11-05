local owner, ft
local flo = 0
local vec
local aprg, aprg2 = 0, 0
local w, h = ScrW(), ScrH()
function GM:PlayerBindPress(client, bind, pressed)
    bind = bind:lower()
    if (bind:find("use") or bind:find("attack")) and pressed then
        local menu, callback = lia.menu.getActiveMenu()
        if menu and lia.menu.onButtonPressed(menu, callback) then
            return true
        elseif bind:find("use") and pressed then
            local entity = client:GetTracedEntity()
            if IsValid(entity) and (entity:GetClass() == "lia_item" or entity.hasMenu == true) then
                hook.Run("ItemShowEntityMenu", entity)
            end
        end
    elseif bind:find("jump") then
        lia.command.send("chargetup")
    end
end

function GM:CharacterListLoaded()
    timer.Create(
        "liaWaitUntilPlayerValid",
        1,
        0,
        function()
            if not IsValid(LocalPlayer()) then return end
            timer.Remove("liaWaitUntilPlayerValid")
            hook.Run("LiliaLoaded")
        end
    )
end

function GM:DrawLiliaModelView(panel, ent)
    if IsValid(ent.weapon) then
        ent.weapon:DrawModel()
    end
end

function GM:OnChatReceived()
    if system.IsWindows() and not system.HasFocus() then
        system.FlashWindow()
    end
end

function GM:HUDPaint()
    self:DeathHUDPaint()
    self:MiscHUDPaint()
end

function GM:PlayerButtonDown(client, button)
    if button == KEY_F2 and IsFirstTimePredicted() then
        local menu = DermaMenu()
        menu:AddOption(
            "Change voice mode to Whispering range.",
            function()
                netstream.Start("ChangeSpeakMode", "Whispering")
                client:ChatPrint("You have changed your voice mode to Whispering!")
            end
        )

        menu:AddOption(
            "Change voice mode to Talking range.",
            function()
                netstream.Start("ChangeSpeakMode", "Talking")
                client:ChatPrint("You have changed your voice mode to Talking!")
            end
        )

        menu:AddOption(
            "Change voice mode to Yelling range.",
            function()
                netstream.Start("ChangeSpeakMode", "Yelling")
                client:ChatPrint("You have changed your voice mode to Yelling!")
            end
        )

        menu:Open()
        menu:MakePopup()
        menu:Center()
    end
end

function GM:InitializedConfig()
    hook.Run("LoadLiliaFonts", lia.config.Font, lia.config.GenericFont)
end

function GM:ClientPostInit()
    lia.joinTime = RealTime() - 0.9716
    lia.faction.formatModelData()
    if system.IsWindows() and not system.HasFocus() then
        system.FlashWindow()
    end

    timer.Create(
        "FixShadows",
        10,
        0,
        function()
            for _, player in ipairs(player.GetAll()) do
                player:DrawShadow(false)
            end

            for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
                if IsValid(v) and v:isDoor() then
                    v:DrawShadow(false)
                end
            end
        end
    )
end

function GM:DeathHUDPaint()
    owner = LocalPlayer()
    ft = FrameTime()
    if owner:getChar() then
        if owner:Alive() then
            if aprg ~= 0 then
                aprg2 = math.Clamp(aprg2 - ft * 1.3, 0, 1)
                if aprg2 == 0 then
                    aprg = math.Clamp(aprg - ft * .7, 0, 1)
                end
            end
        else
            if aprg2 ~= 1 then
                aprg = math.Clamp(aprg + ft * .5, 0, 1)
                if aprg == 1 then
                    aprg2 = math.Clamp(aprg2 + ft * .4, 0, 1)
                end
            end
        end
    end

    if IsValid(lia.char.gui) and lia.gui.char:IsVisible() or not owner:getChar() then return end
    if aprg > 0.01 then
        surface.SetDrawColor(0, 0, 0, math.ceil((aprg ^ .5) * 255))
        surface.DrawRect(-1, -1, w + 2, h + 2)
        local tx, ty = lia.util.drawText(L"youreDead", w / 2, h / 2, ColorAlpha(color_white, aprg2 * 255), 1, 1, "liaDynFontMedium", aprg2 * 255)
    end

function GM:TooltipInitialize(var, panel)
    if panel.liaToolTip or panel.itemID then
        var.markupObject = lia.markup.parse(var:GetText(), ScrW() * .15)
        var:SetText("")
        var:SetWide(math.max(ScrW() * .15, 200) + 12)
        var:SetHeight(var.markupObject:getHeight() + 12)
        var:SetAlpha(0)
        var:AlphaTo(255, 0.2, 0)
        var.isItemTooltip = true
    end
end

function GM:TooltipPaint(var, w, h)
    if var.isItemTooltip then
        lia.util.drawBlur(var, 2, 2)
        surface.SetDrawColor(0, 0, 0, 230)
        surface.DrawRect(0, 0, w, h)
        if var.markupObject then
            var.markupObject:draw(12 * 0.5, 12 * 0.5 + 2)
        end

        return true
    end
end

function GM:TooltipLayout(var)
    if var.isItemTooltip then return true end
end

function GM:StartChat()
    net.Start("liaTypeStatus")
    net.WriteBool(false)
    net.SendToServer()
end

function GM:FinishChat()
    net.Start("liaTypeStatus")
    net.WriteBool(true)
    net.SendToServer()
end

concommand.Add(
    "vgui_cleanup",
    function()
        for k, v in pairs(vgui.GetWorldPanel():GetChildren()) do
            if not (v.Init and debug.getinfo(v.Init, "Sln").short_src:find("chatbox")) then
                v:Remove()
            end
        end
    end, nil, "Removes every panel that you have left over (like that errored DFrame filling up your screen)"
)