MODULE.name = "1.1 Inventory Compatibility"
MODULE.author = "Cheesenut"
MODULE.desc = "Adds compatibility for the old 1.1 inventory."

lia.util.include("sv_migrations.lua")

if (SERVER) then
	function MODULE:NutScriptTablesLoaded()
		-- Only migrate data on dedicated servers.
		if (not game.IsDedicated()) then return end
		
		-- If the migration has not started before, start it.
		local data = self:getData(nil, true, true)
		if (data and data.lastMigration) then return end
		local currentHibernationBool = GetConVar("sv_hibernate_think"):GetBool()
		lia.data.set("currentHibernationBool", currentHibernationBool, true, true)
		game.ConsoleCommand("sv_hibernate_think 1\n")
		local WAIT = 10

		-- Add a bot to start timers.
		game.ConsoleCommand("bot\n")
		print("Waiting 10 seconds for inventory migration...")

		-- Do not let players interfere with data migration.
		game.ConsoleCommand("kickall\n")

		hook.Add("CheckPassword", "liaInvDBMigration", function()
			return false, "NutScript inventory data migration in progress"
		end)
			
		timer.Simple(WAIT, function()
			game.ConsoleCommand("lia_migrateinv\n")
		end)
	end
end
