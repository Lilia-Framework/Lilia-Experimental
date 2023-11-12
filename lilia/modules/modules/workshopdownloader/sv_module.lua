--------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    if lia.config.GamemodeWorkshop then
        for i = 1, #lia.config.GamemodeWorkshop do
            resource.AddWorkshop(lia.config.GamemodeWorkshop[i])
        end
    end

    if lia.config.AutoWorkshopDownloader and engine.GetAddons() then
        for i = 1, #engine.GetAddons() do
            resource.AddWorkshop(engine.GetAddons()[i].wsid)
        end
    end

    resource.AddWorkshop("2959728255")
end
--------------------------------------------------------------------------------------------------------------------------
