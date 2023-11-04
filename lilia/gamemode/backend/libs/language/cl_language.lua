
LIA_CVAR_LANG = CreateClientConVar("lia_language", lia.config.language or "english", true, true)

function L(key, ...)
    local languages = lia.lang.stored
    local langKey = LIA_CVAR_LANG:GetString()
    local info = languages[langKey] or languages.english

    return string.format(info and info[key] or key, ...)
end


function L2(key, ...)
    local langKey = LIA_CVAR_LANG:GetString()
    local info = lia.lang.stored[langKey]
    if info and info[key] then return string.format(info[key], ...) end
end
