﻿----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.intSpawnDelay = 8
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.intUpdateDistance = 5500
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.intUpdateRate = 1
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.intUpdateAmount = 512
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.NumpadActive = false
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.tblAlwaysSend = {"player", "func_lod", "gmod_hands", "worldspawn", "player_manager", "gmod_gamerules", "bodyque", "network", "soundent", "prop_door_rotating", "phys_slideconstraint", "phys_bone_follower", "class C_BaseEntity", "func_physbox", "logic_auto", "env_tonemap_controller", "shadow_control", "env_sun", "lua_run", "func_useableladder", "info_ladder_dismount", "func_illusionary", "env_fog_controller", "prop_vehicle_jeep"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.ClientTimersToRemove = {"HintSystem_OpeningMenu", "HintSystem_Annoy1", "HintSystem_Annoy2", "HostnameThink", "CheckHookTimes"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.Perfomancekillers = {"class C_PhysPropClientside", "class C_ClientRagdoll"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.ServerTimersToRemove = {"HostnameThink", "CheckHookTimes",}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.RemovableHooks = {
    ["StartChat"] = {"StartChatIndicator",},
    ["FinishChat"] = {"EndChatIndicator",},
    ["PostPlayerDraw"] = {"DarkRP_ChatIndicator",},
    ["CreateClientsideRagdoll"] = {"DarkRP_ChatIndicator",},
    ["player_disconnect"] = {"DarkRP_ChatIndicator",},
    ["PostDrawEffects"] = {"RenderWidgets", "RenderHalos",},
    ["PlayerTick"] = {"TickWidgets",},
    ["PlayerSay"] = {"ULXMeCheck",},
    ["OnEntityCreated"] = {"WidgetInit",},
    ["PlayerInitialSpawn"] = {"PlayerAuthSpawn", "VJBaseSpawn", "drvrejplayerInitialSpawn"},
    ["RenderScene"] = {"RenderStereoscopy", "RenderSuperDoF",},
    ["LoadGModSave"] = {"LoadGModSave",},
    ["RenderScreenspaceEffects"] = {"RenderColorModify", "RenderBloom", "RenderToyTown", "RenderTexturize", "RenderSunbeams", "RenderSobel", "RenderSharpen", "RenderMaterialOverlay", "RenderMotionBlur", "RenderBokeh",},
    ["GUIMousePressed"] = {"SuperDOFMouseDown",},
    ["GUIMouseReleased"] = {"SuperDOFMouseUp",},
    ["PreventScreenClicks"] = {"SuperDOFPreventClicks",},
    ["PostRender"] = {"RenderFrameBlend",},
    ["PreRender"] = {"PreRenderFrameBlend",},
    ["Think"] = {"DOFThink", "CheckSchedules"},
    ["NeedsDepthPass"] = {"NeedsDepthPass_Bokeh",},
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.EntitiesToBeRemoved = {
    ["env_fire"] = true,
    ["trigger_hurt"] = true,
    ["prop_ragdoll"] = true,
    ["prop_physics"] = true,
    ["spotlight_end"] = true,
    ["light"] = true,
    ["point_spotlight"] = true,
    ["beam"] = true,
    ["env_sprite"] = true,
    ["light_spot"] = true,
    ["func_tracktrain"] = true,
    ["point_template"] = true,
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.ServerStartupConsoleCommand = {
    ["ai_serverragdolls"] = "1",
    ["mem_max_heapsize"] = "131072",
    ["mem_max_heapsize_dedicated"] = "131072",
    ["mem_min_heapsize"] = "131072",
    ["threadpool_affinity"] = "64",
    ["decalfrequency"] = "10",
    ["gmod_physiterations"] = "2",
    ["sv_minrate"] = "1048576",
    ["mat_antialias"] = "2",
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.ClientStartupConsoleCommand = {
    ["sgm_ignore_warnings"] = "1",
    ["fast_fogvolume"] = "0",
    ["mat_managedtextures"] = "1",
    ["net_maxpacketdrop"] = "5000",
    ["net_chokeloop"] = "0",
    ["net_splitpacket_maxrate"] = "1048576",
    ["net_compresspackets_minsize"] = "1024",
    ["net_maxfragments"] = "1260",
    ["net_maxfilesize"] = "16",
    ["net_maxcleartime"] = "4",
    ["cl_lagcompensation"] = "0",
    ["cl_timeout"] = "30",
    ["cl_smoothtime"] = "0.1",
    ["cl_localnetworkbackdoor"] = "0",
    ["cl_cmdrate"] = "30",
    ["cl_updaterate"] = "20",
    ["ai_expression_optimization"] = "1",
    ["filesystem_max_stdio_read"] = "64",
    ["in_usekeyboardsampletime"] = "1",
    ["r_radiosity"] = "4",
    ["rate"] = "1048576",
    ["filesystem_unbuffered_io"] = "1",
    ["snd_mix_async"] = "0",
    ["snd_async_fullyasync"] = "0",
    ["snd_async_minsize"] = "262144",
    ["cl_forcepreload"] = "0",
    ["cl_playerspraydisable"] = "1",
    ["pac_debug_clmdl"] = "1",
    ["cl_resend"] = "11",
    ["cl_jiggle_bone_framerate_cutoff"] = "4",
    ["ragdoll_sleepaftertime"] = "40.0f",
    ["cl_timeout"] = "3000",
    ["gmod_mcore_test"] = "1",
    ["r_shadows"] = "1",
    ["cl_detaildist"] = "0",
    ["cl_threaded_client_leaf_system"] = "1",
    ["cl_threaded_bone_setup"] = "2",
    ["r_threaded_renderables"] = "1",
    ["r_threaded_particles"] = "1",
    ["r_queued_ropes"] = "1",
    ["r_queued_decals"] = "1",
    ["r_queued_post_processing"] = "1",
    ["r_threaded_client_shadow_manager"] = "1",
    ["studio_queue_mode"] = "1",
    ["mat_queue_mode"] = "2",
    ["fov_desired"] = "100",
    ["mat_specular"] = "0",
    ["r_drawmodeldecals"] = "0",
    ["r_lod"] = "-1",
    ["lia_cheapblur"] = "1",
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
lia.config.VJBaseConsoleCommands = {
    ["vj_npc_processtime"] = "1",
    ["vj_npc_corpsefade"] = "1",
    ["vj_npc_corpsefadetime"] = "5",
    ["vj_npc_nogib"] = "1",
    ["vj_npc_nosnpcchat"] = "1",
    ["vj_npc_slowplayer"] = "1",
    ["vj_npc_noproppush"] = "1",
    ["vj_npc_nothrowgrenade"] = "1",
    ["vj_npc_fadegibstime"] = "5",
    ["vj_npc_knowenemylocation"] = "1",
    ["vj_npc_dropweapon"] = "0",
    ["vj_npc_plypickupdropwep"] = "0",
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------