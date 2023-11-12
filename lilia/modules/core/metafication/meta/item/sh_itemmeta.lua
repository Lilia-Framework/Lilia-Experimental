﻿--------------------------------------------------------------------------------------------------------------------------
local ITEM = lia.meta.item or {}
--------------------------------------------------------------------------------------------------------------------------
debug.getregistry().Item = lia.meta.item
--------------------------------------------------------------------------------------------------------------------------
ITEM.__index = ITEM
--------------------------------------------------------------------------------------------------------------------------
ITEM.name = "INVALID ITEM"
--------------------------------------------------------------------------------------------------------------------------
ITEM.description = ITEM.desc or "[[INVALID ITEM]]"
--------------------------------------------------------------------------------------------------------------------------
ITEM.desc = ITEM.desc or "[[INVALID ITEM]]"
--------------------------------------------------------------------------------------------------------------------------
ITEM.id = ITEM.id or 0
--------------------------------------------------------------------------------------------------------------------------
ITEM.uniqueID = "undefined"
--------------------------------------------------------------------------------------------------------------------------
ITEM.isItem = true
--------------------------------------------------------------------------------------------------------------------------
ITEM.isStackable = false
--------------------------------------------------------------------------------------------------------------------------
ITEM.quantity = 1
--------------------------------------------------------------------------------------------------------------------------
ITEM.maxQuantity = 1
--------------------------------------------------------------------------------------------------------------------------
ITEM.canSplit = true
--------------------------------------------------------------------------------------------------------------------------
function ITEM:getQuantity()
    if self.id == 0 then return self.maxQuantity end
    return self.quantity
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:__eq(other)
    return self:getID() == other:getID()
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:__tostring()
    return "item[" .. self.uniqueID .. "][" .. self.id .. "]"
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getID()
    return self.id
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getModel()
    return self.model
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getSkin()
    return self.skin
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getPrice()
    local price = self.price
    if self.calcPrice then price = self:calcPrice(self.price) end
    return price or 0
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:call(method, client, entity, ...)
    local oldPlayer, oldEntity = self.player, self.entity
    self.player = client or self.player
    self.entity = entity or self.entity
    if type(self[method]) == "function" then
        local results = {self[method](self, ...)}
        self.player = oldPlayer
        self.entity = oldEntity
        return unpack(results)
    end

    self.player = oldPlayer
    self.entity = oldEntity
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getOwner()
    local inventory = lia.inventory.instances[self.invID]
    if inventory and SERVER then return inventory:getRecipients()[1] end
    local id = self:getID()
    for _, v in ipairs(player.GetAll()) do
        local character = v:getChar()
        if character and character:getInv() and character:getInv().items[id] then return v end
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getData(key, default)
    self.data = self.data or {}
    if key == true then return self.data end
    local value = self.data[key]
    if value ~= nil then return value end
    if IsValid(self.entity) then
        local data = self.entity:getNetVar("data", {})
        local value = data[key]
        if value ~= nil then return value end
    end
    return default
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:hook(name, func)
    if name then self.hooks[name] = func end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:postHook(name, func)
    if name then self.postHooks[name] = func end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onRegistered()
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:print(detail)
    if detail == true then
        print(Format("%s[%s]: >> [%s](%s,%s)", self.uniqueID, self.id, self.owner, self.gridX, self.gridY))
    else
        print(Format("%s[%s]", self.uniqueID, self.id))
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:printData()
    self:print(true)
    print("ITEM DATA:")
    for k, v in pairs(self.data) do
        print(Format("[%s] = %s", k, v))
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:Print(detail)
    if detail == true then
        print(Format("%s[%s]: >> [%s](%s,%s)", self.uniqueID, self.id, self.owner, self.gridX, self.gridY))
    else
        print(Format("%s[%s]", self.uniqueID, self.id))
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:PrintData()
    self:Print(true)
    print("ITEM DATA:")
    for k, v in pairs(self.data) do
        print(Format("[%s] = %s", k, v))
    end
end

--------------------------------------------------------------------------------------------------------------------------
lia.meta.item = ITEM
--------------------------------------------------------------------------------------------------------------------------
