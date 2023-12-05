
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "rollstrength",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "[number maximum]",
        onRun = function(client, arguments)
            local character = client:getChar()
            local maximum = math.Clamp(arguments[1] or 100, 0, 100)
            local value = math.random(0, maximum) + (character:getAttrib("strength", 0) * lia.config.AttributeRollMultiplier)
            lia.chat.send(client, "roll", tostring(value))
            lia.chat.send(client, "me", "has rolled a Strength skill roll")
        end
    }
)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "rollendurance",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "[number maximum]",
        onRun = function(client, arguments)
            local character = client:getChar()
            local maximum = math.Clamp(arguments[1] or 100, 0, 100)
            local value = math.random(0, maximum) + (character:getAttrib("endurance", 0) * lia.config.AttributeRollMultiplier)
            lia.chat.send(client, "roll", tostring(value))
            lia.chat.send(client, "me", "has rolled an Endurance skill roll")
        end
    }
)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "rollstamina",
    {
        adminOnly = false,
        privilege = "Default User Commands",
        syntax = "[number maximum]",
        onRun = function(client, arguments)
            local character = client:getChar()
            local maximum = math.Clamp(arguments[1] or 100, 0, 100)
            local value = math.random(0, maximum) + (character:getAttrib("stamina", 0) * lia.config.AttributeRollMultiplier)
            lia.chat.send(client, "roll", tostring(value))
            lia.chat.send(client, "me", "has rolled an Stamina skill roll")
        end
    }
)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charsetattrib",
    {
        superAdminOnly = true,
        syntax = "<string charname> <string attribname> <number level>",
        privilege = "Change Attributes",
        onRun = function(client, arguments)
            local attribName = arguments[2]
            if not attribName then return L("invalidArg", client, 2) end
            local attribNumber = arguments[3]
            attribNumber = tonumber(attribNumber)
            if not attribNumber or not isnumber(attribNumber) then return L("invalidArg", client, 3) end
            local target = lia.command.findPlayer(client, arguments[1])
            if IsValid(target) then
                local char = target:getChar()
                if char then
                    for k, v in pairs(lia.attribs.list) do
                        if lia.util.stringMatches(L(v.name, client), attribName) or lia.util.stringMatches(k, attribName) then
                            char:setAttrib(k, math.abs(attribNumber))
                            client:notifyLocalized("attribSet", target:Name(), L(v.name, client), math.abs(attribNumber))
                            return
                        end
                    end
                end
            end
        end
    }
)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.command.add(
    "charaddattrib",
    {
        superAdminOnly = true,
        syntax = "<string charname> <string attribname> <number level>",
        privilege = "Change Attributes",
        onRun = function(client, arguments)
            local attribName = arguments[2]
            if not attribName then return L("invalidArg", client, 2) end
            local attribNumber = arguments[3]
            attribNumber = tonumber(attribNumber)
            if not attribNumber or not isnumber(attribNumber) then return L("invalidArg", client, 3) end
            local target = lia.command.findPlayer(client, arguments[1])
            if IsValid(target) then
                local char = target:getChar()
                if char then
                    for k, v in pairs(lia.attribs.list) do
                        if lia.util.stringMatches(L(v.name, client), attribName) or lia.util.stringMatches(k, attribName) then
                            char:updateAttrib(k, math.abs(attribNumber))
                            client:notifyLocalized("attribUpdate", target:Name(), L(v.name, client), math.abs(attribNumber))
                            return
                        end
                    end
                end
            end
        end
    }
)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
