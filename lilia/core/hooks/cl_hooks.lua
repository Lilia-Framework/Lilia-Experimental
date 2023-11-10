--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerBindPress(client, bind, pressed)
    bind = bind:lower()
    if (bind:find("use") or bind:find("attack")) and pressed then
        local menu, callback = lia.menu.getActiveMenu()
        if menu and lia.menu.onButtonPressed(menu, callback) then
            return true
        elseif bind:find("use") and pressed then
            local entity = client:GetTracedEntity()
            if IsValid(entity) and (entity:GetClass() == "lia_item" or entity.hasMenu == true) then hook.Run("ItemShowEntityMenu", entity) end
        end
    elseif bind:find("jump") then
        lia.command.send("chargetup")
    end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:OnContextMenuOpen()
    self.BaseClass:OnContextMenuOpen()
    vgui.Create("liaQuick")
end

--------------------------------------------------------------------------------------------------------------------------
function GM:OnContextMenuClose()
    self.BaseClass:OnContextMenuClose()
    if IsValid(lia.gui.quick) then lia.gui.quick:Remove() end
end

--------------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------------
function GM:DrawLiliaModelView(panel, ent)
    if IsValid(ent.weapon) then ent.weapon:DrawModel() end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:OnChatReceived()
    if system.IsWindows() and not system.HasFocus() then system.FlashWindow() end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:InitializedConfig()
    hook.Run("LoadLiliaFonts", lia.config.Font, lia.config.GenericFont)
end

--------------------------------------------------------------------------------------------------------------------------
function GM:ClientPostInit()
    lia.joinTime = RealTime() - 0.9716
    lia.faction.formatModelData()
    if system.IsWindows() and not system.HasFocus() then system.FlashWindow() end
    timer.Create(
        "FixShadows",
        10,
        0,
        function()
            for _, player in ipairs(player.GetAll()) do
                player:DrawShadow(false)
            end

            for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
                if IsValid(v) and v:isDoor() then v:DrawShadow(false) end
            end
        end
    )
end

--------------------------------------------------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------------------------------------------------
function GM:TooltipPaint(var, w, h)
    if var.isItemTooltip then
        lia.util.drawBlur(var, 2, 2)
        surface.SetDrawColor(0, 0, 0, 230)
        surface.DrawRect(0, 0, w, h)
        if var.markupObject then var.markupObject:draw(12 * 0.5, 12 * 0.5 + 2) end
        return true
    end
end

--------------------------------------------------------------------------------------------------------------------------
function GM:TooltipLayout(var)
    if var.isItemTooltip then return true end
end

--------------------------------------------------------------------------------------------------------------------------
concommand.Add(
    "vgui_cleanup",
    function()
        for k, v in pairs(vgui.GetWorldPanel():GetChildren()) do
            if not (v.Init and debug.getinfo(v.Init, "Sln").short_src:find("chatbox")) then v:Remove() end
        end
    end,
    nil,
    "Removes every panel that you have left over (like that errored DFrame filling up your screen)"
)
--------------------------------------------------------------------------------------------------------------------------
