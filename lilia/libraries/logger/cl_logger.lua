﻿----------------------------------------------------------------------------------------------
netstream.Hook("liaLogStream", function(logString, flag) MsgC(Color(50, 200, 50), "[SERVER] ", lia.config.LogColor[flag] or color_white, tostring(logString) .. "\n") end)
----------------------------------------------------------------------------------------------
