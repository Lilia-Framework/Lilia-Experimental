----------------------------------------------------------------------------------------------
netstream.Hook(
    "adminClearChat",
    function()
        local chatbox = lia.module.list["chatbox"]
        if chatbox and IsValid(chatbox.panel) then
            chatbox.panel:Remove()
            chatbox:createChat()
        else
            LocalPlayer():ConCommand("fixchatplz")
        end
    end
)
----------------------------------------------------------------------------------------------