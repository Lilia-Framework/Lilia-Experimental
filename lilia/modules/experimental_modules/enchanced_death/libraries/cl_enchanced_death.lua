--------------------------------------------------------------------------------------------------------------------------
local aprg, aprg2 = 0, 0
--------------------------------------------------------------------------------------------------------------------------
local w, h = ScrW(), ScrH()
--------------------------------------------------------------------------------------------------------------------------
function MODULE:CalcView(client, origin, angles, fov)
    local view = self.BaseClass:CalcView(client, origin, angles, fov)
    local entity = Entity(client:getLocalVar("ragdoll", 0))
    local ragdoll = client:GetRagdollEntity()
    if client:GetViewEntity() ~= client then return view end
    if (not client:ShouldDrawLocalPlayer() and IsValid(entity) and entity:IsRagdoll()) or (not LocalPlayer():Alive() and IsValid(ragdoll)) then
        local ent = LocalPlayer():Alive() and entity or ragdoll
        local index = ent:LookupAttachment("eyes")
        if index then
            local data = ent:GetAttachment(index)
            if data then
                view = view or {}
                view.origin = data.Pos
                view.angles = data.Ang
            end

            return view
        end
    end

    return view
end

--------------------------------------------------------------------------------------------------------------------------
function GM:HUDPaint()
    local owner = LocalPlayer()
    local ft = FrameTime()
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
end
--------------------------------------------------------------------------------------------------------------------------