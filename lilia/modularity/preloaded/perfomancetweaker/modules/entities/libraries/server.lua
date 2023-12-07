------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerEnteredVehicle(_, vehicle)
    if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
        vehicle:RemoveEFlags(EFL_NO_THINK_FUNCTION)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PropBreak(_, ent)
    if ent:IsValid() and ent:GetPhysicsObject():IsValid() then
        constraint.RemoveAll(ent)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnEntityCreated(entity)
    if entity:GetClass() == "prop_vehicle_prisoner_pod" then
        entity:AddEFlags(EFL_NO_THINK_FUNCTION)
    end

    if CLIENT and lia.config.DrawEntityShadows then
        entity:DrawShadow(false)
    end

    if entity:IsWidget() then
        hook.Add(
            "PlayerTick",
            "GODisableEntWidgets2",
            function(_, n)
                widgets.PlayerTick(entity, n)
            end
        )
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerInitialSpawn(_)
    local annoying = ents.FindByName("music")
    local val = ents.GetMapCreatedEntity(1733)
    if #annoying > 0 then
        annoying[1]:SetKeyValue("RefireTime", 99999999)
        annoying[1]:Fire("Disable")
        annoying[1]:Fire("Kill")
        val:SetKeyValue("RefireTime", 99999999)
        val:Fire("Disable")
        val:Fire("Kill")
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:InitializedModules()
    for _, v in pairs(ents.GetAll()) do
        if lia.config.EntitiesToBeRemoved[v:GetClass()] then
            v:Remove()
        end
    end

    if lia.config.GarbageCleaningTimer > 0 then
        timer.Create(
            "CleanupGarbage",
            lia.config.GarbageCleaningTimer,
            0,
            function()
                for _, v in ipairs(ents.GetAll()) do
                    if table.HasValue(lia.config.Perfomancekillers, v:GetClass()) then
                        SafeRemoveEntity(v)
                    end
                end

                RunConsoleCommand("r_cleardecals")
            end
        )
    end

    if CLIENT and lia.config.DrawEntityShadows then
        for _, v in ipairs(ents.FindByClass("prop_door_rotating")) do
            if IsValid(v) and v:isDoor() then
                v:DrawShadow(false)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:EntityRemoved(entity)
    if entity:IsRagdoll() and not entity:getNetVar("player", nil) and lia.config.RagdollCleaningTimer > 0 then
        timer.Simple(
            lia.config.RagdollCleaningTimer,
            function()
                if not IsValid(entity) then return end
                entity:SetSaveValue("m_bFadingOut", true)
                timer.Simple(
                    3,
                    function()
                        if not IsValid(entity) then return end
                        entity:Remove()
                    end
                )
            end
        )
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:PlayerLeaveVehicle(_, vehicle)
    if vehicle:GetClass() == "prop_vehicle_prisoner_pod" then
        local sName = "PodFix" .. vehicle:EntIndex()
        hook.Add(
            "Think",
            sName,
            function()
                if vehicle:IsValid() then
                    local tSave = vehicle:GetSaveTable()
                    if tSave.m_bEnterAnimOn then
                        hook.Remove("Think", sName)
                    elseif not tSave.m_bExitAnimOn then
                        vehicle:AddEFlags(EFL_NO_THINK_FUNCTION)
                        hook.Remove("Think", sName)
                    end
                else
                    hook.Remove("Think", sName)
                end
            end
        )
    end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------