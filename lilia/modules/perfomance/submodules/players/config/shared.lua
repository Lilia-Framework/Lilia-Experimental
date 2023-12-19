﻿------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Entities that transmit States ]]
PlayerPerfomance.tblAlwaysSend = {"player", "func_lod", "gmod_hands", "worldspawn", "player_manager", "gmod_gamerules", "bodyque", "network", "soundent", "prop_door_rotating", "phys_slideconstraint", "phys_bone_follower", "class C_BaseEntity", "func_physbox", "logic_auto", "env_tonemap_controller", "shadow_control", "env_sun", "lua_run", "func_useableladder", "info_ladder_dismount", "func_illusionary", "env_fog_controller", "prop_vehicle_jeep"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Commands to be run by the player on creation ]]
PlayerPerfomance.OnCreateConsoleCommands = {
    ["rope_smooth"] = "0",
    ["Rope_wind_dist"] = "0",
    ["Rope_shake"] = "0",
    ["violence_ablood"] = "1",
    ["mat_queue_mode"] = "-1",
    ["cl_threaded_bone_setup"] = "1",
    ["gmod_mcore_test"] = "1",
    ["cl_threaded_client_leaf_system"] = "0",
    ["r_queued_ropes"] = "1",
    ["r_threaded_client_shadow_manager"] = "1",
    ["r_fastzreject"] = "-1",
    ["Cl_ejectbrass"] = "0",
    ["Muzzleflash_light"] = "0",
    ["cl_wpn_sway_interp"] = "0",
    ["in_usekeyboardsampletime"] = "0",
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------