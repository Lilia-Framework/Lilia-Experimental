--------------------------------------------------------------------------------------------------------------------------
local ITEM = lia.meta.item or {}
--------------------------------------------------------------------------------------------------------------------------
debug.getregistry().Item = lia.meta.item
ITEM.__index = ITEM
--------------------------------------------------------------------------------------------------------------------------
function ITEM:getName()
    return self.name
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getDesc()
    return self.desc
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:removeFromInventory(preserveItem)
    local inventory = lia.inventory.instances[self.invID]
    self.invID = 0
    if inventory then return inventory:removeItem(self:getID(), preserveItem) end
    local d = deferred.new()
    d:resolve()

    return d
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:delete()
    self:destroy()

    return lia.db.delete("items", "_itemID = " .. self:getID()):next(
        function()
            self:onRemoved()
        end
    )
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:remove()
    local d = deferred.new()
    if IsValid(self.entity) then
        self.entity:Remove()
    end

    self:removeFromInventory():next(
        function()
            d:resolve()

            return self:delete()
        end
    )

    return d
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:destroy()
    net.Start("liaItemDelete")
    net.WriteUInt(self:getID(), 32)
    net.Broadcast()
    lia.item.instances[self:getID()] = nil
    self:onDisposed()
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onDisposed()
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:getEntity()
    local id = self:getID()
    for k, v in ipairs(ents.FindByClass("lia_item")) do
        if v.liaItemID == id then return v end
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:spawn(position, angles)
    local instance = lia.item.instances[self.id]
    if instance then
        if IsValid(instance.entity) then
            instance.entity.liaIsSafe = true
            instance.entity:Remove()
        end

        local client
        if type(position) == "Player" then
            client = position
            position = position:getItemDropPos()
        end

        local entity = ents.Create("lia_item")
        entity:Spawn()
        entity:SetPos(position)
        entity:SetAngles(angles or Angle(0, 0, 0))
        entity:setItem(self.id)
        instance.entity = entity
        if IsValid(client) then
            entity.SteamID64 = client:SteamID()
            entity.liaCharID = client:getChar():getID()
        end

        return entity
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:transfer(newInventory, bBypass)
    if not bBypass and not newInventory:canAccess("transfer") then return false end
    local inventory = lia.inventory.instances[self.invID]
    inventory:removeItem(self.id, true):next(
        function()
            newInventory:add(self)
        end
    )

    return true
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onInstanced(id)
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onSync(recipient)
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onRemoved()
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:onRestored(inventory)
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:sync(recipient)
    net.Start("liaItemInstance")
    net.WriteUInt(self:getID(), 32)
    net.WriteString(self.uniqueID)
    net.WriteTable(self.data)
    net.WriteType(self.invID)
    net.WriteUInt(self.quantity, 32)
    if recipient == nil then
        net.Broadcast()
    else
        net.Send(recipient)
    end

    self:onSync(recipient)
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:setData(key, value, receivers, noSave, noCheckEntity)
    self.data = self.data or {}
    self.data[key] = value
    if not noCheckEntity then
        local ent = self:getEntity()
        if IsValid(ent) then
            ent:setNetVar("data", self.data)
        end
    end

    if receivers or self:getOwner() then
        netstream.Start(receivers or self:getOwner(), "invData", self:getID(), key, value)
    end

    if noSave or not lia.db then return end
    if key == "x" or key == "y" then
        value = tonumber(value)
        if MYSQLOO_PREPARED then
            lia.db.preparedCall("item" .. key, nil, value, self:getID())
        else
            lia.db.updateTable(
                {
                    ["_" .. key] = value
                }, nil, "items", "_itemID = " .. self:getID()
            )
        end

        return
    end

    local x, y = self.data.x, self.data.y
    self.data.x, self.data.y = nil, nil
    if MYSQLOO_PREPARED then
        lia.db.preparedCall("itemData", nil, self.data, self:getID())
    else
        lia.db.updateTable(
            {
                _data = self.data
            }, nil, "items", "_itemID = " .. self:getID()
        )
    end

    self.data.x, self.data.y = x, y
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:addQuantity(quantity, receivers, noCheckEntity)
    self:setQuantity(self:getQuantity() + quantity, receivers, noCheckEntity)
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:setQuantity(quantity, receivers, noCheckEntity)
    self.quantity = quantity
    if not noCheckEntity then
        local ent = self:getEntity()
        if IsValid(ent) then
            ent:setNetVar("quantity", self.quantity)
        end
    end

    if receivers or self:getOwner() then
        netstream.Start(receivers or self:getOwner(), "invQuantity", self:getID(), self.quantity)
    end

    if noSave or not lia.db then return end
    if MYSQLOO_PREPARED then
        lia.db.preparedCall("itemq", nil, self.quantity, self:getID())
    else
        lia.db.updateTable(
            {
                _quantity = self.quantity
            }, nil, "items", "_itemID = " .. self:getID()
        )
    end
end

--------------------------------------------------------------------------------------------------------------------------
function ITEM:interact(action, client, entity, data)
    assert(type(client) == "Player" and IsValid(client), "Item action cannot be performed without a player")
    local canInteract, reason = hook.Run("CanPlayerInteractItem", client, action, self, data)
    if canInteract == false then
        if reason then
            client:notifyLocalized(reason)
        end

        return false
    end

    local oldPlayer, oldEntity = self.player, self.entity
    self.player = client
    self.entity = entity
    local callback = self.functions[action]
    if not callback then
        self.player = oldPlayer
        self.entity = oldEntity

        return false
    end

    canInteract = isfunction(callback.onCanRun) and not callback.onCanRun(self, data) or true
    if not canInteract then
        self.player = oldPlayer
        self.entity = oldEntity

        return false
    end

    local result
    if isfunction(self.hooks[action]) then
        result = self.hooks[action](self, data)
    end

    if result == nil and isfunction(callback.onRun) then
        result = callback.onRun(self, data)
    end

    if self.postHooks[action] then
        self.postHooks[action](self, result, data)
    end

    hook.Run("OnPlayerInteractItem", client, action, self, result, data)
    if result ~= false and not deferred.isPromise(result) then
        if IsValid(entity) then
            entity:Remove()
        else
            self:remove()
        end
    end

    self.player = oldPlayer
    self.entity = oldEntity

    return true
end

--------------------------------------------------------------------------------------------------------------------------
lia.meta.item = ITEM
--------------------------------------------------------------------------------------------------------------------------