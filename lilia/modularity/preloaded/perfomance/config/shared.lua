------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Timers to be removed on the client ]]
MODULE.ClientTimersToRemove = {"HintSystem_OpeningMenu", "HintSystem_Annoy1", "HintSystem_Annoy2", "HostnameThink", "CheckHookTimes"}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Timers to be removed on the Server ]]
MODULE.ServerTimersToRemove = {"HostnameThink", "CheckHookTimes",}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Hooks to be removed ]]
MODULE.RemovableHooks = {
    ["StartChat"] = {"StartChatIndicator",},
    ["FinishChat"] = {"EndChatIndicator",},
    ["PostPlayerDraw"] = {"DarkRP_ChatIndicator",},
    ["CreateClientsideRagdoll"] = {"DarkRP_ChatIndicator",},
    ["player_disconnect"] = {"DarkRP_ChatIndicator",},
    ["PostDrawEffects"] = {"RenderWidgets", "RenderHalos",},
    ["PlayerTick"] = {"TickWidgets",},
    ["OnEntityCreated"] = {"WidgetInit",},
    ["PlayerInitialSpawn"] = {"PlayerAuthSpawn"},
    ["LoadGModSave"] = {"LoadGModSave",},
    ["GUIMousePressed"] = {"SuperDOFMouseDown",},
    ["GUIMouseReleased"] = {"SuperDOFMouseUp",},
    ["PreventScreenClicks"] = {"SuperDOFPreventClicks",},
    ["Think"] = {"DOFThink", "CheckSchedules"},
    ["NeedsDepthPass"] = {"NeedsDepthPass_Bokeh",},
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Console Commands to be run on the server ]]
MODULE.ServerStartupConsoleCommand = {
    ["ai_serverragdolls"] = "1", -- Enables server-side ragdolls for AI
    ["threadpool_affinity"] = "8", -- Affinity mask for the thread pool
    ["gmod_physiterations"] = "2", -- Number of physics iterations per frame in GMod
}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[ Console Commands to be run on the client ]]
MODULE.ClientStartupConsoleCommand = {
    ["net_maxpacketdrop"] = "5000", -- Maximum number of packet drops before the client considers the connection as bad
    ["net_chokeloop"] = "0", -- Controls the chokeloop behavior (choke is a network term related to packet loss)
    ["net_splitpacket_maxrate"] = "1048576", -- Maximum rate at which split packets are sent
    ["net_compresspackets_minsize"] = "1024", -- Minimum size for compressed network packets
    ["net_maxfragments"] = "1260", -- Maximum number of packet fragments
    ["net_maxfilesize"] = "16", -- Maximum allowed file size for network transfers
    ["net_maxcleartime"] = "4", -- Maximum time to spend clearing the network channel
    ["snd_mix_async"] = "0", -- Enables asynchronous sound mixing
    ["snd_async_fullyasync"] = "0", -- Makes sound processing fully asynchronous
    ["snd_async_minsize"] = "262144", -- Minimum size of asynchronous sound buffers
    ["cl_lagcompensation"] = "0", -- Enables lag compensation for clients
    ["cl_smoothtime"] = "0.1", -- Smoothing factor for player movement
    ["cl_localnetworkbackdoor"] = "0", -- Enables a local network backdoor (may be a developer option)
    ["cl_cmdrate"] = "30", -- Number of command packets sent to the server per second
    ["cl_updaterate"] = "20", -- Number of update packets received from the server per second
    ["cl_forcepreload"] = "0", -- Forces preloading of assets
    ["cl_resend"] = "11", -- Number of times a packet is resent
    ["cl_jiggle_bone_framerate_cutoff"] = "4", -- Frame rate cutoff for jiggle bone animation
    ["cl_timeout"] = "3000", -- Connection timeout duration
    ["cl_threaded_bone_setup"] = "2", -- Level of threading for bone setup
    ["mat_managedtextures"] = "1", -- Enables managed textures
    ["r_threaded_renderables"] = "1", -- Enables threaded renderables
    ["r_threaded_particles"] = "1", -- Enables threaded particles
    ["r_queued_ropes"] = "1", -- Enables queued rendering for ropes
    ["r_queued_decals"] = "1", -- Enables queued rendering for decals
    ["r_queued_post_processing"] = "1", -- Enables queued rendering for post-processing effects
    ["r_threaded_client_shadow_manager"] = "1", -- Enables threaded client shadow manager
    ["r_drawmodeldecals"] = "0", -- Enables drawing model decals
    ["r_shadows"] = "1", -- Enables shadows
    ["r_radiosity"] = "4", -- Radiosity settings
    ["ai_expression_optimization"] = "1", -- Enables expression optimization for AI
    ["filesystem_max_stdio_read"] = "64", -- Maximum stdio read size for the filesystem
    ["in_usekeyboardsampletime"] = "1", -- Enables keyboard sample time
    ["fast_fogvolume"] = "0", -- Enables fast fog volume calculations
    ["filesystem_unbuffered_io"] = "1", -- Enables unbuffered I/O for the filesystem
    ["ragdoll_sleepaftertime"] = "40.0f", -- Time before ragdolls go to sleep
    ["studio_queue_mode"] = "1", -- Studio queue mode
    ["gmod_mcore_test"] = "1", -- Test for GMod multicore support
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
