
local MODULE = MODULE

include("shared.lua")

AddCSLuaFile("cl_init.lua")

AddCSLuaFile("shared.lua")

function ENT:SpawnFunction(client, trace)
    local angles = (trace.HitPos - client:GetPos()):Angle()
    angles.r = 0
    angles.p = 0
    angles.y = angles.y + 180
    local entity = ents.Create("lia_vendor")
    entity:SetPos(trace.HitPos)
    entity:SetAngles(angles)
    entity:Spawn()
    MODULE:saveVendors()

    return entity
end


function ENT:Use(activator)
    if not hook.Run("CanPlayerAccessVendor", activator, self) then
        if self.messages[VENDOR_NOTRADE] then
            activator:ChatPrint(self:getNetVar("name") .. ": " .. L(self.messages[VENDOR_NOTRADE], activator))
        end

        return
    end

    self.receivers[#self.receivers + 1] = activator
    activator.liaVendor = self
    if self.messages[VENDOR_WELCOME] then
        activator:ChatPrint(self:getNetVar("name") .. ": " .. self.messages[VENDOR_WELCOME])
    end

    hook.Run("PlayerAccessVendor", activator, self)
end


function ENT:setMoney(value)
    if not isnumber(value) or value < 0 then
        value = nil
    end

    self.money = value
    net.Start("liaVendorMoney")
    net.WriteInt(value or -1, 32)
    net.Send(self.receivers)
end


function ENT:giveMoney(value)
    if self.money then
        self:setMoney(self:getMoney() + value)
    end
end


function ENT:takeMoney(value)
    if self.money then
        self:giveMoney(-value)
    end
end


function ENT:setStock(itemType, value)
    self.items[itemType] = self.items[itemType] or {}
    if not self.items[itemType][VENDOR_MAXSTOCK] then
        self:setMaxStock(itemType, value)
    end

    self.items[itemType][VENDOR_STOCK] = math.Clamp(value, 0, self.items[itemType][VENDOR_MAXSTOCK])
    net.Start("liaVendorStock")
    net.WriteString(itemType)
    net.WriteUInt(value, 32)
    net.Send(self.receivers)
end


function ENT:addStock(itemType, value)
    local current = self:getStock(itemType)
    if not current then return end
    self:setStock(itemType, self:getStock(itemType) + (value or 1))
end


function ENT:takeStock(itemType, value)
    if not self.items[itemType] or not self.items[itemType][VENDOR_MAXSTOCK] then return end
    self:addStock(itemType, -(value or 1))
end


function ENT:setMaxStock(itemType, value)
    if value == 0 or not isnumber(value) then
        value = nil
    end

    self.items[itemType] = self.items[itemType] or {}
    self.items[itemType][VENDOR_MAXSTOCK] = value
    net.Start("liaVendorMaxStock")
    net.WriteString(itemType)
    net.WriteUInt(value, 32)
    net.Send(self.receivers)
end


function ENT:setFactionAllowed(factionID, isAllowed)
    if isAllowed then
        self.factions[factionID] = true
    else
        self.factions[factionID] = nil
    end

    net.Start("liaVendorAllowFaction")
    net.WriteUInt(factionID, 8)
    net.WriteBool(self.factions[factionID] == true)
    net.Send(self.receivers)
    for _, client in ipairs(self.receivers) do
        if not hook.Run("CanPlayerAccessVendor", client, self) then
            self:removeReceiver(client)
        end
    end
end


function ENT:setClassAllowed(classID, isAllowed)
    if isAllowed then
        self.classes[classID] = true
    else
        self.classes[classID] = nil
    end

    net.Start("liaVendorAllowClass")
    net.WriteUInt(classID, 8)
    net.WriteBool(self.classes[classID] == true)
    net.Send(self.receivers)
end


function ENT:removeReceiver(client, requestedByPlayer)
    table.RemoveByValue(self.receivers, client)
    if client.liaVendor == self then
        client.liaVendor = nil
    end

    if requestedByPlayer then return end
    net.Start("liaVendorExit")
    net.Send(client)
end


local ALLOWED_MODES = {
    [VENDOR_SELLANDBUY] = true,
    [VENDOR_SELLONLY] = true,
    [VENDOR_BUYONLY] = true
}


function ENT:setName(name)
    self:setNetVar("name", name)
    net.Start("liaVendorEdit")
    net.WriteString("name")
    net.Send(self.receivers)
end


function ENT:setDesc(desc)
    self:setNetVar("desc", desc)
    net.Start("liaVendorEdit")
    net.WriteString("desc")
    net.Send(self.receivers)
end


function ENT:setNoBubble(noBubble)
    self:setNetVar("noBubble", noBubble)
    net.Start("liaVendorEdit")
    net.WriteString("bubble")
    net.Send(self.receivers)
end


function ENT:setTradeMode(itemType, mode)
    if not ALLOWED_MODES[mode] then
        mode = nil
    end

    self.items[itemType] = self.items[itemType] or {}
    self.items[itemType][VENDOR_MODE] = mode
    net.Start("liaVendorMode")
    net.WriteString(itemType)
    net.WriteInt(mode or -1, 8)
    net.Send(self.receivers)
end


function ENT:setItemPrice(itemType, value)
    if not isnumber(value) or value < 0 then
        value = nil
    end

    self.items[itemType] = self.items[itemType] or {}
    self.items[itemType][VENDOR_PRICE] = value
    net.Start("liaVendorPrice")
    net.WriteString(itemType)
    net.WriteInt(value or -1, 32)
    net.Send(self.receivers)
end


function ENT:setItemStock(itemType, value)
    if not isnumber(value) or value < 0 then
        value = nil
    end

    self.items[itemType] = self.items[itemType] or {}
    self.items[itemType][VENDOR_STOCK] = value
    net.Start("liaVendorStock")
    net.WriteString(itemType)
    net.WriteInt(value, 32)
    net.Send(self.receivers)
end


function ENT:setItemMaxStock(itemType, value)
    if not isnumber(value) or value < 0 then
        value = nil
    end

    self.items[itemType] = self.items[itemType] or {}
    self.items[itemType][VENDOR_MAXSTOCK] = value
    net.Start("liaVendorMaxStock")
    net.WriteString(itemType)
    net.WriteInt(value, 32)
    net.Send(self.receivers)
end


function ENT:OnRemove()
    LIA_VENDORS[self:EntIndex()] = nil
    net.Start("liaVendorExit")
    net.Send(self.receivers)
    if lia.shuttingDown or self.liaIsSafe then return end
    MODULE:saveVendors()
end


function ENT:setModel(model)
    assert(isstring(model), "model must be a string")
    model = model:lower()
    self:SetModel(model)
    self:setAnim()
    net.Start("liaVendorEdit")
    net.WriteString("model")
    net.Send(self.receivers)
end


function ENT:setSellScale(scale)
    assert(isnumber(scale), "scale must be a number")
    self:setNetVar("scale", scale)
    net.Start("liaVendorEdit")
    net.WriteString("scale")
    net.Send(self.receivers)
end


function ENT:sync(client)
    net.Start("liaVendorSync")
    net.WriteEntity(self)
    net.WriteInt(self:getMoney() or -1, 32)
    net.WriteUInt(table.Count(self.items), 16)
    for itemType, item in pairs(self.items) do
        net.WriteString(itemType)
        net.WriteInt(item[VENDOR_PRICE] or -1, 32)
        net.WriteInt(item[VENDOR_STOCK] or -1, 32)
        net.WriteInt(item[VENDOR_MAXSTOCK] or -1, 32)
        net.WriteInt(item[VENDOR_MODE] or -1, 8)
    end

    net.Send(client)
    if client:CanEditVendor() then
        for factionID in pairs(self.factions) do
            net.Start("liaVendorAllowFaction")
            net.WriteUInt(factionID, 8)
            net.WriteBool(true)
            net.Send(client)
        end

        for classID in pairs(self.classes) do
            net.Start("liaVendorAllowClass")
            net.WriteUInt(classID, 8)
            net.WriteBool(true)
            net.Send(client)
        end
    end
end


function ENT:addReceiver(client, noSync)
    if not table.HasValue(self.receivers, client) then
        self.receivers[#self.receivers + 1] = client
    end

    if noSync then return end
    self:sync(client)
end
