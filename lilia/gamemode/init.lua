DeriveGamemode("sandbox")
lia = lia or {
    util = {},
    meta = {}
}

AddCSLuaFile("lilia/core/config.lua")
AddCSLuaFile("lilia/core/includer.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("lilia/core/config.lua")
include("lilia/core/includer.lua")
include("lilia/core/data.lua")
include("lilia/core/database.lua")
AddCSLuaFile("lilia/core/pre_initialize.lua")
include("lilia/core/pre_initialize.lua")
AddCSLuaFile("lilia/core/initialize.lua")
include("lilia/core/initialize.lua")
AddCSLuaFile("lilia/core/server_initialize.lua")
include("lilia/core/server_initialize.lua")
AddCSLuaFile("lilia/core/loader.lua")
include("lilia/core/loader.lua")