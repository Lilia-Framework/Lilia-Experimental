function GM:PostGamemodeLoaded()
    print("Disabling base_gmodentity think method")
    scripted_ents.GetStored("base_gmodentity").t.Think = nil
end

function GM:LiliaLoaded()
    local namecache = {}
    for _, MODULE in pairs(lia.module.list) do
        local authorID = (tonumber(MODULE.author) and tostring(MODULE.author)) or (string.match(MODULE.author, "STEAM_") and util.SteamIDTo64(MODULE.author)) or nil
        if authorID then
            if namecache[authorID] ~= nil then
                MODULE.author = namecache[authorID]
            else
                steamworks.RequestPlayerInfo(
                    authorID,
                    function(newName)
                        namecache[authorID] = newName
                        MODULE.author = newName or MODULE.author
                    end
                )
            end
        end
    end

    lia.module.namecache = namecache
end

cvars.AddChangeCallback(
    "lia_cheapblur",
    function(name, old, new)
        local useCheapBlur = CreateClientConVar("lia_cheapblur", 0, true):GetBool() or false
        useCheapBlur = (tonumber(new) or 0) > 0
    end
)