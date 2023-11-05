--------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    local PSAString = [[
            /*
            
            PUBLIC SERVICE ANNOUNCEMENT FOR LILIA SERVER OWNERS
            
            There is a ENOURMOUS performance issue with ULX Admin mod.
            Lilia Development Team found ULX is the main issue
            that make the server freeze when player count is higher
            than 20-30. The duration of freeze will be increased as you get
            more players on your server.
            
            If you're planning to open big server with ULX/ULib, Lilia
            Development Team does not recommend your plan. Server Performance
            Issues with ULX/Ulib on your server will be ignored and we're
            going to consider that you're taking the risk of ULX/Ulib's
            critical performance issue.
            
            Lilia 1.2 only displays this message when you have ULX or
            ULib on your server.
            
                                           -Lilia Development Team
            
            */]]
    MsgC(Color(255, 0, 0), PSAString .. "\n")
end
--------------------------------------------------------------------------------------------------------------------------