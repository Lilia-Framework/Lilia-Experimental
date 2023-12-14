------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "fixpac",
    {
        syntax = "<No Input>",
        onRun = function(client)
            timer.Simple(0, function() if IsValid(client) then client:ConCommand("pac_clear_parts") end end)
            timer.Simple(
                0.5,
                function()
                    if IsValid(client) then
                        client:ConCommand("pac_urlobj_clear_cache")
                        client:ConCommand("pac_urltex_clear_cache")
                    end
                end
            )

            timer.Simple(1.0, function() if IsValid(client) then client:ConCommand("pac_restart") end end)
            timer.Simple(1.5, function() if IsValid(client) then client:ChatPrint("PAC has been successfully restarted. You might need to run this command twice!") end end)
        end
    }
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
