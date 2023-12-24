﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function FrameworkHUD:LoadFonts(_)
    surface.CreateFont(
        "FrameworkHUD_Small",
        {
            font = "Product Sans",
            size = 17
        }
    )

    surface.CreateFont(
        "FrameworkHUD_Medium",
        {
            font = "Product Sans",
            size = 20
        }
    )

    surface.CreateFont(
        "FrameworkHUD_Large",
        {
            font = "Product Sans",
            size = 24,
            weight = 800
        }
    )

    surface.CreateFont(
        "FrameworkHUD_XLarge",
        {
            font = "Product Sans",
            size = 35,
            weight = 800
        }
    )

    surface.CreateFont(
        "FrameworkHUD_Enormous",
        {
            font = "Product Sans",
            size = 54
        }
    )
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
