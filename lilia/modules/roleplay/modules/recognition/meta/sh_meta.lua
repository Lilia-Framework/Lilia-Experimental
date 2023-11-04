
local charMeta = lia.meta.character

function charMeta:doesRecognize(id)
    if not isnumber(id) and id.getID then id = id:getID() end
    return hook.Run("IsCharRecognized", self, id) ~= false
end
