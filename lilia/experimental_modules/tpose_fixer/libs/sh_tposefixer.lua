--------------------------------------------------------------------------------------------------------------------------
function GM:InitializedModules()
    for _, model in pairs(lia.config.PlayerModelTposingFixer) do
        lia.anim.setModelClass(model, "player")
    end
end
--------------------------------------------------------------------------------------------------------------------------