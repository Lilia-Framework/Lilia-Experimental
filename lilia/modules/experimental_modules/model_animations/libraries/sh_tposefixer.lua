--------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    for _, model in pairs(lia.config.PlayerModelTposingFixer) do
        lia.anim.setModelClass(model, "player")
    end

    for tpose, animtype in pairs(lia.config.DefaultTposingFixer) do
        lia.anim.setModelClass(tpose, animtype)
    end
end
--------------------------------------------------------------------------------------------------------------------------
