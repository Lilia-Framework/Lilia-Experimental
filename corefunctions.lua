function GM:OnContextMenuOpen()
end

function GM:OnContextMenuClose()
end

function GM:LoadNutFonts(font, genericFont)
end

function GM:CreateLoadingScreen()
end

function GM:ShouldCreateLoadingScreen()
end

function GM:InitializedConfig()
end

function GM:CharacterListLoaded()
end

function GM:InitPostEntity()
end

function GM:CalcView(client, origin, angles, fov)
end

function GM:HUDPaintBackground()
end

function GM:ShouldDrawEntityInfo(entity)
end

function GM:PlayerBindPress(client, bind, pressed)
end

function GM:ItemShowEntityMenu(entity)
end

function GM:SetupQuickMenu(menu)
end

function GM:DrawNutModelView(panel, ent)
end

function GM:ScreenResolutionChanged(oldW, oldH)
end

function GM:NutScriptLoaded()
end

function GM:PlayerNoClip(client)
end

function GM:TranslateActivity(client, act)
end

function GM:DoAnimationEvent(client, event, data)
end

function GM:EntityEmitSound(data)
end

function GM:HandlePlayerLanding(client, velocity, wasOnGround)
end

function GM:CalcMainActivity(client, velocity)
end

function GM:OnCharVarChanged(char, varName, oldVar, newVar)
end

function GM:GetDefaultCharName(client, faction)
end

function GM:GetDefaultCharDesc(client, faction)
end

function GM:CanPlayerUseChar(client, char)
end

function GM:CheckFactionLimitReached(faction, character, client)
end

function GM:CanProperty(client, property, entity)
end

function GM:PhysgunPickup(client, entity)
end

function GM:Move(client, moveData)
end

function GM:CanItemBeTransfered(itemObject, curInv, inventory)
end

function GM:SetupBotCharacter(client)
end

function GM:SetupBotInventory(client, character)
end

function GM:PlayerInitialSpawn(client)
end

function GM:PlayerUse(client, entity)
end

function GM:KeyPress(client, key)
end

function GM:KeyRelease(client, key)
end

function GM:CanPlayerDropItem(client, item)
end

function GM:CanPlayerInteractItem(client, action, item)
end

function GM:CanPlayerTakeItem(client, item)
end

function GM:PlayerShouldTakeDamage(client, attacker)
end

function GM:EntityTakeDamage(entity, dmgInfo)
end

function GM:PrePlayerLoadedChar(client, character, lastChar)
end

function GM:PlayerLoadedChar(client, character, lastChar)
end

function GM:CharacterLoaded(id)
end

function GM:PlayerSay(client, message)
end

function GM:PlayerSpawn(client)
end

function GM:PlayerSpawnNPC(client, npcType, weapon)
end

function GM:PlayerSpawnSWEP(client, weapon, info)
end

function GM:PlayerSpawnProp(client)
end

function GM:PlayerSpawnRagdoll(client)
end

function GM:PlayerSpawnVehicle(client, model, name, data)
end

function GM:PlayerLoadout(client)
end

function GM:PostPlayerLoadout(client)
end

function GM:PlayerDeath(client, inflictor, attacker)
end

function GM:PlayerHurt(client, attacker, health, damage)
end

function GM:PlayerDeathThink(client)
end

function GM:PlayerDisconnected(client)
end

function GM:PlayerAuthed(client, steamID, uniqueID)
end

function GM:InitPostEntity()
end

function GM:ShutDown()
end

function GM:PlayerDeathSound()
end

function GM:InitializedSchema()
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
end

function GM:OnPhysgunFreeze(weapon, physObj, entity, client)
end

function GM:CanPlayerSuicide(client)
end

function GM:AllowPlayerPickup(client, entity)
end

function GM:PreCleanupMap()
end

function GM:PostCleanupMap()
end

function GM:CharacterPreSave(character)
end

function GM:OnServerLog(client, logType, ...)
end

function GM:GetPreferredCarryAngles(entity)
end

function GM:InitializedPlugins()
end

function GM:CreateDefaultInventory(character)
end

function GM:NutScriptTablesLoaded()
end

function GM:PluginShouldLoad(plugin)
end

function GM:GetSalaryInterval(client, faction)
end

function GM:CreateSalaryTimer(client)
end

function GM:GetGameDescription()
end

function GM:OnPlayerJoinClass(client, class, oldClass)
end

function GM:OnPickupMoney(client, moneyEntity)
end

function GM:SetupDatabase()
end

function GM:OnMySQLOOConnected()
end

function GM:RegisterPreparedStatements()
end

function GM:Initialize()
end

function GM:OnReloaded()
end
