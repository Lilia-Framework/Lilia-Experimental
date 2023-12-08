----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:LiliaLoaded()
    vgui.Create("liaCharacter")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:KickedFromCharacter(id, isCurrentChar)
    if isCurrentChar then vgui.Create("liaCharacter") end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:CreateMenuButtons(tabs)
    tabs["characters"] = function(panel)
        if IsValid(lia.gui.menu) then lia.gui.menu:Remove() end
        if MODULE.KickOnEnteringMainMenu then netstream.Start("liaCharKickSelf") end
        vgui.Create("liaCharacter")
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------