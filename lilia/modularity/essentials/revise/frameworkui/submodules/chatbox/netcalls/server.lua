﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
netstream.Hook(
    "msg",
    function(client, text)
        local charlimit = lia.config.MaxChatLength
        if charlimit > 0 then
            if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
                hook.Run("PlayerSay", client, text)
                client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
            end
        else
            if utf8.len(text) > charlimit then
                client:notify(string.format("Your message has been shortened due to being longer than %s characters!", charlimit))
            else
                if (client.liaNextChat or 0) < CurTime() and text:find("%S") then
                    hook.Run("PlayerSay", client, text)
                    client.liaNextChat = CurTime() + math.max(#text / 250, 0.4)
                end
            end
        end
    end
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
