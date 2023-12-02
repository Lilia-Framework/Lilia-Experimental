------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnEntityCreated(entity)
    local sClass = eTarget:GetClass():lower():Trim()
    if sClass == "lua_run" then
        function eTarget:AcceptInput()
            return true
        end

        function eTarget:RunCode()
            return true
        end

        timer.Simple(
            0,
            function()
                eTarget:Remove()
            end
        )
    elseif sClass == "point_servercommand" then
        timer.Simple(
            0,
            function()
                eTarget:Remove()
            end
        )
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(client)
    if not game.SinglePlayer() then
        timer.Simple(
            0,
            function()
                if IsValid(client) == false or client:IsBot() or client:IsListenServerHost() or client.IsFullyAuthenticated == nil or client:IsFullyAuthenticated() then return end
                client:Kick("Your SteamID wasn't fully authenticated, try restarting steam.")
            end
        )
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------