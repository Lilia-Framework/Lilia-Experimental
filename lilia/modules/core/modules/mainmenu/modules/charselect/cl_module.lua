
function MODULE:LiliaLoaded()
    vgui.Create("liaCharacter")
end


function MODULE:KickedFromCharacter(id, isCurrentChar)
    if isCurrentChar then
        vgui.Create("liaCharacter")
    end
end
