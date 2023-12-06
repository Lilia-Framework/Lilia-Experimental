PLUGIN.name = "Scoreboard"
PLUGIN.author = "Cheesenut"
PLUGIN.desc = "A simple scoreboard that supports recognition."

local staffGroups = {
    ["superadmin"] = true,
    ["Director"] = true,
    ["Lead Administrator"] = true,
    ["Lead Developer"] = true,
    ["Developer"] = true,
    ["Learning Developer"] = true,
    ["Old Administrator"] = true,
    ["Veteran Administrator"] = true,
    ["Senior Administrator"] = true,
    ["Administrator"] = true,
    ["Senior Moderator"] = true,
    ["Moderator"] = true,
    ["Trial Moderator"] = true
}

local managementGroups = {
    ["superadmin"] = true,
    ["Director"] = true,
    ["Lead Administrator"] = true,
    ["Lead Developer"] = true,
    ["Developer"] = true,
    ["Learning Developer"] = true,
}

if (CLIENT) then
	function PLUGIN:ScoreboardHide()
		if !LocalPlayer():getChar() then return false end
		if (IsValid(nut.gui.score)) then
			nut.gui.score:SetVisible(false)
			CloseDermaMenus()
		end

		gui.EnableScreenClicker(false)
		return true
	end

	function PLUGIN:ScoreboardShow()
		if !LocalPlayer():getChar() then return false end
		if (IsValid(nut.gui.score) && LocalPlayer():getChar()) then
			nut.gui.score:SetVisible(true)

			local staffCount = 0
			local playerCount = 0
			for _,ply in ipairs(player.GetAll()) do
				if staffGroups[ply:GetUserGroup()] && !ply.isAFK then
					staffCount = staffCount + 1
				end
			end

			nut.gui.score.staffListHeader:SetText("Staff Online: "..staffCount)
		else
			vgui.Create("nutScoreboard")
		end

		gui.EnableScreenClicker(true)
		return true
	end

	function PLUGIN:OnReloaded()
		-- Reload the scoreboard.
		if (IsValid(nut.gui.score)) then
			nut.gui.score:Remove()
		end
	end

	function PLUGIN:ShowPlayerOptions(client, options)
		if ((LocalPlayer() == client) or (managementGroups[LocalPlayer():GetUserGroup()]) or (LocalPlayer():Team() == FACTION_HIDDEN)) then
			options[" View Profile"] = {"icon16/user.png", function()
				if (IsValid(client)) then
					client:ShowProfile()
				end
			end}
			options[" Copy Steam ID"] = {"icon16/user.png", function()
				if (IsValid(client)) then
					SetClipboardText(client:SteamID())
					LocalPlayer():ChatPrint("Copied "..client:SteamID().. " to clipboard.")
				end
			end}
			if managementGroups[LocalPlayer():GetUserGroup()] or (LocalPlayer():Team() == FACTION_HIDDEN) then
				options["Goto"] = {"icon16/arrow_right.png", function()
					if (IsValid(client)) then
						LocalPlayer():ConCommand("sam goto "..client:SteamID())
					end
				end}
				options["Bring"] = {"icon16/arrow_down.png", function()
					if (IsValid(client)) then
						LocalPlayer():ConCommand("sam bring "..client:SteamID())
					end
				end}
				options["Return"] = {"icon16/arrow_redo.png", function()
					if (IsValid(client)) then
						LocalPlayer():ConCommand("sam return "..client:SteamID())
					end
				end}
			end
		end
	end
end

nut.config.add(
	"sbWidth",
	0.325,
	"Scoreboard's width within percent of screen width.",
	function(oldValue, newValue)
		if (CLIENT and IsValid(nut.gui.score)) then
			nut.gui.score:Remove()
		end
	end,
	{
		form = "Float",
		category = "visual",
		data = {min = 0.2, max = 1}
	}
)

nut.config.add(
	"sbHeight",
	0.825,
	"Scoreboard's height within percent of screen height.",
	function(oldValue, newValue)
		if (CLIENT and IsValid(nut.gui.score)) then
			nut.gui.score:Remove()
		end
	end,
	{
		form = "Float",
		category = "visual",
		data = {min = 0.3, max = 1}
	}
)

nut.config.add(
	"sbTitle",
	GetHostName(),
	"The title of the scoreboard.",
	function(oldValue, newValue)
		if (CLIENT and IsValid(nut.gui.score)) then
			nut.gui.score:Remove()
		end
	end,
	{
		category = "visual"
	}
)

nut.config.add(
	"sbRecog",
	false,
	"Whether or not recognition is used in the scoreboard.",
	nil,
	{
		category = "characters"
	}
)