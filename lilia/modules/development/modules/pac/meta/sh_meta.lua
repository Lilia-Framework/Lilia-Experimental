
if not pac then return end

local playerMeta = FindMetaTable("Entity")

function playerMeta:getParts()
	return self:getNetVar("parts", {})
end
