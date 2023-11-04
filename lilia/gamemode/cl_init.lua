
DeriveGamemode("sandbox")

lia = lia or {
    util = {},
    gui = {},
    meta = {}
}


include("config.lua")

include("includer.lua")

include("loader.lua")

include("shared.lua")

CreateConVar("cl_weaponcolor", "0.30 1.80 2.10", {FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD}, "The value is a Vector - so between 0-1 - not between 0-255")
