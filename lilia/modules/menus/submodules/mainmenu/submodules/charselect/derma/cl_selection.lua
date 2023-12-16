﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local PANEL = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function PANEL:Init()
    self:Dock(FILL)
    self:DockMargin(0, 64, 0, 0)
    self:InvalidateParent(true)
    self:InvalidateLayout(true)
    self.panels = {}
    self.scroll = self:Add("liaHorizontalScroll")
    self.scroll:Dock(FILL)
    local scrollBar = self.scroll:GetHBar()
    scrollBar:SetTall(8)
    scrollBar:SetHideButtons(true)
    scrollBar.Paint = function(scroll, w, h)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawRect(0, 0, w, h)
    end

    scrollBar.btnGrip.Paint = function(grip, w, h)
        local alpha = 50
        if scrollBar.Dragging then
            alpha = 150
        elseif grip:IsHovered() then
            alpha = 100
        end

        surface.SetDrawColor(255, 255, 255, alpha)
        surface.DrawRect(0, 0, w, h)
    end

    self:createCharacterSlots()
    hook.Add(
        "CharacterListUpdated",
        self,
        function()
            self:createCharacterSlots()
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function PANEL:createCharacterSlots()
    local alignment = MainMenu.CharMenuAlignment
    self.scroll:Clear()
    if #lia.characters == 0 then return lia.gui.character:showContent() end
    local totalWide = 0
    for _, id in ipairs(lia.characters) do
        local character = lia.char.loaded[id]
        if not character then continue end
        local panel = self.scroll:Add("liaCharacterSlot")
        totalWide = totalWide + panel:GetWide() + 8
        panel:Dock(LEFT)
        panel:DockMargin(0, 0, 8, 8)
        panel:setCharacter(character)
        panel.onSelected = function(panel)
            self:onCharacterSelected(character)
        end
    end

    totalWide = totalWide - 8
    self.scroll:SetWide(self:GetWide())
    local multiplier = alignment == "center" and 0.5 or alignment == "left" and 0 or 1
    self.scroll:DockMargin(math.max(0, self.scroll:GetWide() * multiplier - totalWide * multiplier), 0, 0, 0)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function PANEL:onCharacterSelected(character)
    if self.choosing then return end
    if character == LocalPlayer():getChar() then return lia.gui.character:fadeOut() end
    self.choosing = true
    lia.gui.character:setFadeToBlack(true):next(function() return MainMenu:chooseCharacter(character:getID()) end):next(
        function(err)
            self.choosing = false
            if IsValid(lia.gui.character) then
                timer.Simple(
                    0.25,
                    function()
                        if not IsValid(lia.gui.character) then return end
                        lia.gui.character:setFadeToBlack(false)
                        lia.gui.character:Remove()
                    end
                )
            end
        end,
        function(err)
            self.choosing = false
            lia.gui.character:setFadeToBlack(false)
            lia.util.notify(err)
        end
    )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
vgui.Register("liaCharacterSelection", PANEL, "EditablePanel")
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------