local entityMeta = FindMetaTable("Entity")
local ChairCache = {}
function entityMeta:isChair()
    return ChairCache[self:GetModel()]
end

for k, v in pairs(list.Get("Vehicles")) do
    if v.Category == "Chairs" then
        ChairCache[v.Model] = true
    end
end