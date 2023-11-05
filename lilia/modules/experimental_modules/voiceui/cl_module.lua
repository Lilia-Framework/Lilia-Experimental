--------------------------------------------------------------------------------------------------------------------------
VoicePanels = {}
--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerStartVoice(client)
    if not IsValid(g_VoicePanelList) or not lia.config.AllowVoice then return end
    hook.Run("PlayerEndVoice", client)
    if IsValid(VoicePanels[client]) then
        if VoicePanels[client].fadeAnim then
            VoicePanels[client].fadeAnim:Stop()
            VoicePanels[client].fadeAnim = nil
        end

        VoicePanels[client]:SetAlpha(255)

        return
    end

    if not IsValid(client) then return end
    local pnl = g_VoicePanelList:Add("VoicePanel")
    pnl:Setup(client)
    VoicePanels[client] = pnl
end

--------------------------------------------------------------------------------------------------------------------------
function GM:PlayerEndVoice(client)
    if IsValid(VoicePanels[client]) then
        if VoicePanels[client].fadeAnim then return end
        VoicePanels[client].fadeAnim = Derma_Anim("FadeOut", VoicePanels[client], VoicePanels[client].FadeOut)
        VoicePanels[client].fadeAnim:Start(2)
    end
end
--------------------------------------------------------------------------------------------------------------------------
function GM:InitPostEntity()
    if IsValid(g_VoicePanelList) then
        g_VoicePanelList:Remove()
    end

    g_VoicePanelList = vgui.Create("DPanel")
    g_VoicePanelList:ParentToHUD()
    g_VoicePanelList:SetSize(270, ScrH() - 200)
    g_VoicePanelList:SetPos(ScrW() - 320, 100)
    g_VoicePanelList:SetPaintBackground(false)
end

--------------------------------------------------------------------------------------------------------------------------
timer.Create(
    "VoiceClean",
    10,
    0,
    function()
        for k, v in pairs(VoicePanels) do
            if not IsValid(k) then
                hook.Run("PlayerEndVoice", k)
            end
        end
    end
)
--------------------------------------------------------------------------------------------------------------------------