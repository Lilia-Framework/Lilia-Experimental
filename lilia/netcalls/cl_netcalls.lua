﻿lia.config.CustomChatSound = lia.config.CustomChatSound or ""
netstream.Hook("notifyQuery", lia.util.notifQuery)
net.Receive(
    "liaNotifyL",
    function()
        local message = net.ReadString()
        local length = net.ReadUInt(8)
        if length == 0 then return lia.util.notifyLocalized(message) end
        local args = {}
        for i = 1, length do
            args[i] = net.ReadString()
        end

        lia.util.notifyLocalized(message, unpack(args))
    end
)

net.Receive(
    "liaStringReq",
    function()
        local id = net.ReadUInt(32)
        local title = net.ReadString()
        local subTitle = net.ReadString()
        local default = net.ReadString()
        if title:sub(1, 1) == "@" then title = L(title:sub(2)) end
        if subTitle:sub(1, 1) == "@" then subTitle = L(subTitle:sub(2)) end
        Derma_StringRequest(
            title,
            subTitle,
            default,
            function(text)
                net.Start("liaStringReq")
                net.WriteUInt(id, 32)
                net.WriteString(text)
                net.SendToServer()
            end
        )
    end
)

net.Receive(
    "liaNotify",
    function()
        local message = net.ReadString()
        lia.util.notify(message)
    end
)

net.Receive(
    "liaInventoryData",
    function()
        local id = net.ReadType()
        local key = net.ReadString()
        local value = net.ReadType()
        local instance = lia.inventory.instances[id]
        if not instance then
            ErrorNoHalt("Got data " .. key .. " for non-existent instance " .. id)
            return
        end

        local oldValue = instance.data[key]
        instance.data[key] = value
        instance:onDataChanged(key, oldValue, value)
        hook.Run("InventoryDataChanged", instance, key, oldValue, value)
    end
)

net.Receive(
    "liaInventoryInit",
    function()
        local id = net.ReadType()
        local typeID = net.ReadString()
        local data = net.ReadTable()
        local instance = lia.inventory.new(typeID)
        instance.id = id
        instance.data = data
        instance.items = {}
        local length = net.ReadUInt(32)
        local data2 = net.ReadData(length)
        local uncompressed_data = util.Decompress(data2)
        local items = util.JSONToTable(uncompressed_data)
        local function readItem(I)
            local c = items[I]
            return c.i, c.u, c.d, c.q
        end

        local datatable = items
        local expectedItems = #datatable
        for i = 1, expectedItems do
            local itemID, itemType, data, quantity = readItem(i)
            local item = lia.item.new(itemType, itemID)
            item.data = table.Merge(item.data, data)
            item.invID = instance.id
            item.quantity = quantity
            instance.items[itemID] = item
            hook.Run("ItemInitialized", item)
        end

        lia.inventory.instances[instance.id] = instance
        hook.Run("InventoryInitialized", instance)
        for _, character in pairs(lia.char.loaded) do
            for index, inventory in pairs(character.vars.inv) do
                if inventory:getID() == id then character.vars.inv[index] = instance end
            end
        end
    end
)

net.Receive(
    "liaInventoryAdd",
    function()
        local itemID = net.ReadUInt(32)
        local invID = net.ReadType()
        local item = lia.item.instances[itemID]
        local inventory = lia.inventory.instances[invID]
        if item and inventory then
            inventory.items[itemID] = item
            hook.Run("InventoryItemAdded", inventory, item)
        end
    end
)

net.Receive(
    "liaInventoryRemove",
    function()
        local itemID = net.ReadUInt(32)
        local invID = net.ReadType()
        local item = lia.item.instances[itemID]
        local inventory = lia.inventory.instances[invID]
        if item and inventory and inventory.items[itemID] then
            inventory.items[itemID] = nil
            item.invID = 0
            hook.Run("InventoryItemRemoved", inventory, item)
        end
    end
)

net.Receive(
    "liaInventoryDelete",
    function()
        local invID = net.ReadType()
        local instance = lia.inventory.instances[invID]
        if instance then hook.Run("InventoryDeleted", instance) end
        if invID then lia.inventory.instances[invID] = nil end
    end
)

net.Receive(
    "liaItemInstance",
    function()
        local itemID = net.ReadUInt(32)
        local itemType = net.ReadString()
        local data = net.ReadTable()
        local item = lia.item.new(itemType, itemID)
        local invID = net.ReadType()
        local quantity = net.ReadUInt(32)
        item.data = table.Merge(item.data or {}, data)
        item.invID = invID
        item.quantity = quantity
        lia.item.instances[itemID] = item
        hook.Run("ItemInitialized", item)
    end
)

net.Receive("cleanup_inbound", function() chat.AddText(Color(255, 0, 0), "[ WARNING ]  Map Cleanup Inbound! Brace for Impact!") end)
net.Receive("worlditem_cleanup_inbound", function() chat.AddText(Color(255, 0, 0), "[ WARNING ]  World items will be cleared in 10 Minutes!") end)
net.Receive("worlditem_cleanup_inbound_final", function() chat.AddText(Color(255, 0, 0), "[ WARNING ]  World items will be cleared in 60 Seconds!") end)
net.Receive("map_cleanup_inbound", function() chat.AddText(Color(255, 0, 0), "[ WARNING ]  Automatic Map Cleanup in 10 Minutes!") end)
net.Receive("map_cleanup_inbound_final", function() chat.AddText(Color(255, 0, 0), "[ WARNING ]  Automatic Map Cleanup in 60 Seconds!") end)
net.Receive(
    "death_client",
    function()
        local date = lia.date.GetFormattedDate("[DEATH]: ", true, true, true, true, true)
        local nick = net.ReadString()
        local charid = net.ReadFloat()
        chat.AddText(Color(255, 255, 255), date, "  You were killed by " .. nick .. "[" .. charid .. "]")
    end
)

net.Receive(
    "liaCharacterInvList",
    function()
        local charID = net.ReadUInt(32)
        local length = net.ReadUInt(32)
        local inventories = {}
        for i = 1, length do
            inventories[i] = lia.inventory.instances[net.ReadType()]
        end

        local character = lia.char.loaded[charID]
        if character then character.vars.inv = inventories end
    end
)

net.Receive(
    "liaItemDelete",
    function()
        local id = net.ReadUInt(32)
        local instance = lia.item.instances[id]
        if instance and instance.invID then
            local inventory = lia.inventory.instances[instance.invID]
            if not inventory or not inventory.items[id] then return end
            inventory.items[id] = nil
            instance.invID = 0
            hook.Run("InventoryItemRemoved", inventory, instance)
        end

        lia.item.instances[id] = nil
        hook.Run("ItemDeleted", instance)
    end
)

netstream.Hook("charInfo", function(data, id, client) lia.char.loaded[id] = lia.char.new(data, id, client == nil and LocalPlayer() or client) end)
netstream.Hook(
    "charSet",
    function(key, value, id)
        id = id or (LocalPlayer():getChar() and LocalPlayer():getChar().id)
        local character = lia.char.loaded[id]
        if character then
            local oldValue = character.vars[key]
            character.vars[key] = value
            hook.Run("OnCharVarChanged", character, key, oldValue, value)
        end
    end
)

netstream.Hook(
    "charVar",
    function(key, value, id)
        id = id or (LocalPlayer():getChar() and LocalPlayer():getChar().id)
        local character = lia.char.loaded[id]
        if character then
            local oldVar = character:getVar()[key]
            character:getVar()[key] = value
            hook.Run("OnCharLocalVarChanged", character, key, oldVar, value)
        end
    end
)

netstream.Hook(
    "charData",
    function(id, key, value)
        local character = lia.char.loaded[id]
        if character then
            character.vars.data = character.vars.data or {}
            character:getData()[key] = value
        end
    end
)

netstream.Hook("charKick", function(id, isCurrentChar) hook.Run("KickedFromCharacter", id, isCurrentChar) end)
netstream.Hook("liaSyncGesture", function(entity, a, b, c) if IsValid(entity) then entity:AnimRestartGesture(a, b, c) end end)
netstream.Hook(
    "item",
    function(uniqueID, id, data, invID)
        local item = lia.item.new(uniqueID, id)
        item.data = {}
        if data then item.data = data end
        item.invID = invID or 0
        hook.Run("ItemInitialized", item)
    end
)

netstream.Hook(
    "invData",
    function(id, key, value)
        local item = lia.item.instances[id]
        if item then
            item.data = item.data or {}
            local oldValue = item.data[key]
            item.data[key] = value
            hook.Run("ItemDataChanged", item, key, oldValue, value)
        end
    end
)

netstream.Hook(
    "invQuantity",
    function(id, quantity)
        local item = lia.item.instances[id]
        if item then
            local oldValue = item:getQuantity()
            item.quantity = quantity
            hook.Run("ItemQuantityChanged", item, oldValue, quantity)
        end
    end
)

netstream.Hook(
    "liaDataSync",
    function(data, first, last)
        lia.localData = data
        lia.firstJoin = first
        lia.lastJoin = last
    end
)

netstream.Hook(
    "liaData",
    function(key, value)
        lia.localData = lia.localData or {}
        lia.localData[key] = value
    end
)

netstream.Hook(
    "attrib",
    function(id, key, value)
        local character = lia.char.loaded[id]
        if character then character:getAttribs()[key] = value end
    end
)

netstream.Hook(
    "nVar",
    function(index, key, value)
        lia.net[index] = lia.net[index] or {}
        lia.net[index][key] = value
    end
)

netstream.Hook("nDel", function(index) lia.net[index] = nil end)
netstream.Hook(
    "nLcl",
    function(key, value)
        lia.net[LocalPlayer():EntIndex()] = lia.net[LocalPlayer():EntIndex()] or {}
        lia.net[LocalPlayer():EntIndex()][key] = value
    end
)

netstream.Hook("gVar", function(key, value) lia.net.globals[key] = value end)
netstream.Hook(
    "seqSet",
    function(entity, sequence)
        if IsValid(entity) then
            if not sequence then
                entity.liaForceSeq = nil
                return
            end

            entity:SetCycle(0)
            entity:SetPlaybackRate(1)
            entity.liaForceSeq = sequence
        end
    end
)

netstream.Hook(
    "cMsg",
    function(client, chatType, text, anonymous)
        if IsValid(client) then
            local class = lia.chat.classes[chatType]
            text = hook.Run("OnChatReceived", client, chatType, text, anonymous) or text
            if class then
                CHAT_CLASS = class
                class.onChatAdd(client, text, anonymous)
                if lia.config.CustomChatSound and lia.config.CustomChatSound ~= "" then
                    surface.PlaySound(lia.config.CustomChatSound)
                else
                    chat.PlaySound()
                end

                CHAT_CLASS = nil
            end
        end
    end
)

netstream.Hook(
    "actBar",
    function(start, finish, text)
        if not text then
            lia.bar.actionStart = 0
            lia.bar.actionEnd = 0
        else
            if text:sub(1, 1) == "@" then text = L(text:sub(2)) end
            lia.bar.actionStart = start
            lia.bar.actionEnd = finish
            lia.bar.actionText = text:upper()
        end
    end
)

netstream.Hook(
    "classUpdate",
    function(joinedClient)
        if lia.gui.classes and lia.gui.classes:IsVisible() then
            if joinedClient == LocalPlayer() then
                lia.gui.classes:loadClasses()
            else
                for k, v in ipairs(lia.gui.classes.classPanels) do
                    local data = v.data
                    v:setNumber(#lia.class.getPlayers(data.index))
                end
            end
        end
    end
)

netstream.Hook("removeF1", function() if IsValid(lia.gui.menu) then lia.gui.menu:remove() end end)
netstream.Hook(
    "adminClearChat",
    function()
        local chat = lia.module.list["chatbox"]
        if chat and IsValid(chat.panel) then
            chat.panel:Remove()
            chat:createChat()
        else
            LocalPlayer():ConCommand("fixchatplz")
        end
    end
)

net.Receive(
    "announcement_client",
    function()
        local message = net.ReadString()
        chat.AddText(Color(255, 56, 252), "[Admin Announcement]: ", Color(255, 255, 255), message)
    end
)

net.Receive(
    "advert_client",
    function()
        local nick = net.ReadString()
        local message = net.ReadString()
        chat.AddText(Color(216, 190, 18), "[Advertisement by " .. nick .. "]: ", Color(255, 255, 255), message)
    end
)

net.Receive(
    "OpenInvMenu",
    function()
        local target = net.ReadEntity()
        local index = net.ReadType()
        local targetInv = lia.inventory.instances[index]
        local myInv = LocalPlayer():getChar():getInv()
        local inventoryDerma = targetInv:show()
        inventoryDerma:SetTitle(target:getChar():getName() .. "'s Inventory")
        inventoryDerma:MakePopup()
        inventoryDerma:ShowCloseButton(true)
        local myInventoryDerma = myInv:show()
        myInventoryDerma:MakePopup()
        myInventoryDerma:ShowCloseButton(true)
        myInventoryDerma:SetParent(inventoryDerma)
        myInventoryDerma:MoveLeftOf(inventoryDerma, 4)
    end
)

net.Receive(
    "OpenDetailedDescriptions",
    function()
        local client = net.ReadEntity()
        local textEntryData = net.ReadString()
        local textEntryDataURL = net.ReadString()
        local Frame = vgui.Create("DFrame")
        Frame:Center()
        Frame:SetPos(Frame:GetPos() - 150, 250, 0)
        Frame:SetSize(350, 500)
        Frame:SetTitle("Detailed Description - " .. client:Name())
        Frame:MakePopup()
        local List = vgui.Create("DListView", Frame)
        List:Dock(FILL)
        List:DockMargin(0, 0, 0, 5)
        List:SetMultiSelect(false)
        local textEntry = vgui.Create("DTextEntry", List)
        textEntry:Dock(FILL)
        textEntry:DockMargin(0, 0, 0, 0)
        textEntry:SetMultiline(true)
        textEntry:SetVerticalScrollbarEnabled(true)
        textEntry:SetText(textEntryData)
        local DButton = vgui.Create("DButton", List)
        if textEntryDataURL == "No detailed description found." then
            DButton:SetDisabled(true)
        else
            DButton:SetTextColor(Color(0, 0, 0, 255))
        end

        DButton:SetText("View Reference Picture")
        DButton:Dock(BOTTOM)
        DButton:DockMargin(0, 0, 0, 0)
        DButton.DoClick = function() gui.OpenURL(textEntryDataURL) end
    end
)

net.Receive(
    "SetDetailedDescriptions",
    function()
        local callingClientsteamName = net.ReadString()
        local Frame = vgui.Create("DFrame")
        Frame:Center()
        Frame:SetPos(Frame:GetPos() - 150, 250, 0)
        Frame:SetSize(350, 500)
        Frame:SetTitle("Edit Detailed Description")
        Frame:MakePopup()
        local List = vgui.Create("DListView", Frame)
        List:Dock(FILL)
        List:DockMargin(0, 0, 0, 5)
        List:SetMultiSelect(false)
        local textEntry = vgui.Create("DTextEntry", List)
        textEntry:Dock(FILL)
        textEntry:DockMargin(0, 0, 0, 0)
        textEntry:SetMultiline(true)
        textEntry:SetVerticalScrollbarEnabled(true)
        if LocalPlayer():getChar():getData("textDetDescData") then textEntry:SetText(LocalPlayer():getChar():getData("textDetDescData")) end
        local DButton = vgui.Create("DButton", List)
        DButton:DockMargin(0, 0, 0, 0)
        DButton:Dock(BOTTOM)
        DButton:SetText("Edit")
        DButton:SetTextColor(Color(0, 0, 0, 255))
        local textEntryURL = vgui.Create("DTextEntry", List)
        textEntryURL:Dock(BOTTOM)
        textEntryURL:DockMargin(0, 0, 0, 0)
        textEntryURL:SetValue("Reference Image URL")
        if LocalPlayer():getChar():getData("textDetDescDataURL") then
            textEntryURL:SetValue(LocalPlayer():getChar():getData("textDetDescDataURL"))
            textEntryURL:SetText(LocalPlayer():getChar():getData("textDetDescDataURL"))
        end

        DButton.DoClick = function()
            net.Start("EditDetailedDescriptions")
            net.WriteString(textEntryURL:GetValue())
            net.WriteString(textEntry:GetValue())
            net.WriteString(callingClientsteamName)
            net.SendToServer()
            Frame:Remove()
        end
    end
)

net.Receive("SendMessage", function() chat.AddText(Color(255, 255, 255), unpack(net.ReadTable())) end)
net.Receive("SendPrint", function() print(unpack(net.ReadTable())) end)
net.Receive("SendPrintTable", function() PrintTable(net.ReadTable()) end)
net.Receive(
    "StringRequest",
    function()
        local time = net.ReadUInt(32)
        local title, subTitle = net.ReadString(), net.ReadString()
        local default = net.ReadString()
        if title:sub(1, 1) == "@" then title = L(title:sub(2)) end
        if subTitle:sub(1, 1) == "@" then subTitle = L(subTitle:sub(2)) end
        Derma_StringRequest(
            title,
            subTitle,
            default or "",
            function(text)
                net.Start("StringRequest")
                net.WriteUInt(time, 32)
                net.WriteString(text)
                net.SendToServer()
            end
        )
    end
)