----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
netstream.Hook(
    "classUpdate",
    function(joinedClient)
        if lia.gui.classes and lia.gui.classes:IsVisible() then
            if joinedClient == LocalPlayer() then
                lia.gui.classes:loadClasses()
            else
                for k, v in ipairs(lia.gui.classes.classPanels) do
                    local data = v.data
                    v:setNumber(#lia.class.getPlayers(data.index))
                end
            end
        end
    end
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------