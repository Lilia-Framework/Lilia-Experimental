----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:ForceDermaSkin()
    if lia.config.DarkTheme then
        return "lilia_darktheme"
    else
        return "lilia"
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:SpawnMenuOpen()
    timer.Simple(
        0,
        function()
            if lia.config.DarkTheme then
                g_SpawnMenu:SetSkin("DarkSpawnMenu")
                g_SpawnMenu:GetToolMenu():SetSkin("DarkSpawnMenu")
                timer.Simple(
                    0,
                    function()
                        derma.RefreshSkins()
                    end
                )
            else
                g_SpawnMenu:SetSkin("Default")
                g_SpawnMenu:GetToolMenu():SetSkin("Default")
                timer.Simple(
                    0,
                    function()
                        derma.RefreshSkins()
                    end
                )
            end
        end
    )
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function MODULE:OnContextMenuOpen()
    timer.Simple(
        0,
        function()
            if lia.config.DarkTheme then
                g_ContextMenu:SetSkin("DarkSpawnMenu")
                timer.Simple(
                    0,
                    function()
                        derma.RefreshSkins()
                    end
                )
            else
                g_ContextMenu:SetSkin("Default")
                timer.Simple(
                    0,
                    function()
                        derma.RefreshSkins()
                    end
                )
            end
        end
    )
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------