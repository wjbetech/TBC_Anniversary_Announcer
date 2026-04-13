local A = Announcer

function Announcer_OnLoad(self)
	SLASH_ANNOUNCER1 = "/announcer"
	SlashCmdList["ANNOUNCER"] = Announcer_SlashCommand
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	A.EnsureOptions()
	A.RefreshTrackedTrinkets()
	A.CreateOptionsPanel()

	A.Message(A.optionLabels.announce..": "..A.ColorText(Announcer_Options.announce))
	A.Message(A.optionLabels.taunt..": "..A.ColorText(Announcer_Options.taunt))
end

function Announcer_OnEvent(self, event, ...)
	A.OnEvent(self, event, ...)
end

function Announcer_SlashCommand(msg)
	msg = string.lower(msg or "")
	if msg == "" then
		A.OpenOptionsPanel()
		A.Message(A.L.openedOptions)
		return
	end

	if msg == "announce" then
		A.ToggleOption("announce")
	elseif msg == "debug" then
		A.ToggleOption("debug")
	elseif msg == "taunt" then
		A.ToggleOption("taunt")
	elseif msg == "options" or msg == "config" then
		A.OpenOptionsPanel()
		A.Message(A.L.openedOptions)
	else
		A.Message(A.L.usage)
	end
end