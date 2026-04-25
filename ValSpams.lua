---@diagnostic disable: undefined-global, undefined-field
local A = _G.ValSpams

local function HandleSlashCommand(msg)
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
	elseif msg == "options" or msg == "config" then
		A.OpenOptionsPanel()
		A.Message(A.L.openedOptions)
	else
		A.Message(A.L.usage)
	end
end


_G.ValSpams_OnLoad = function(self)
	_G.SLASH_VALSPAMS1 = "/vs"
	_G.SLASH_VALSPAMS2 = "/valspams"
	SlashCmdList["VALSPAMS"] = function(msg)
		HandleSlashCommand(msg)
	end
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	A.EnsureOptions()
	A.RefreshTrackedTrinkets()
	A.CreateOptionsPanel()

	A.Message(A.optionLabels.announce..": "..A.ColorText(_G.ValSpams_Options.announce))
end


_G.ValSpams_OnEvent = function(self, event, ...)
	A.OnEvent(self, event, ...)
end