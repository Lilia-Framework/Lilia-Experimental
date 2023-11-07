netstream.Hook(
    "ChangeSpeakMode",
    function(client, mode)
        if not mode then
            mode = "Talking"
        end

        client:setNetVar("VoiceType", mode)
    end
)