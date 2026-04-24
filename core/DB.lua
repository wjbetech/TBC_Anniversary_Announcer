Announcer_Options = Announcer_Options or {}

local A = Announcer

A.optionDefaults = {
	announce = true,
	debug = false,
	trackTrinkets = false,
	showPlayerName = true,
	showTarget = true,
	externalWhispers = false,
	channelMode = "priority",
	announceMode = "ending"
}

A.optionOrder = {
	"announce",
	"trackTrinkets",
	"showPlayerName",
	"showTarget",
	"externalWhispers",
	"debug"
}

function A.SetPref(option, defaultValue)
	if option == nil then
		return defaultValue
	end

	return option
end

function A.GetOptions()
	return Announcer_Options
end

function A.EnsureOptions()
	for optionName, defaultValue in pairs(A.optionDefaults) do
		Announcer_Options[optionName] = A.SetPref(Announcer_Options[optionName], defaultValue)
	end

	Announcer_Options.trackedSpells = A.SetPref(Announcer_Options.trackedSpells, {})
	local trackedSpellDefinitions = A.GetTrackedSpellDefinitions()
	local validTrackedSpellKeys = {}
	for _, spellDefinition in ipairs(trackedSpellDefinitions) do
		validTrackedSpellKeys[spellDefinition.key] = true
	end

	for spellKey in pairs(Announcer_Options.trackedSpells) do
		if not validTrackedSpellKeys[spellKey] then
			Announcer_Options.trackedSpells[spellKey] = nil
		end
	end

	for _, spellDefinition in ipairs(trackedSpellDefinitions) do
		if Announcer_Options.trackedSpells[spellDefinition.key] == nil then
			Announcer_Options.trackedSpells[spellDefinition.key] = true
		end
	end


	if A.announceModeLabels[Announcer_Options.announceMode] == nil then
		Announcer_Options.announceMode = A.optionDefaults.announceMode
	end

	if A.channelModeLabels[Announcer_Options.channelMode] == nil then
		Announcer_Options.channelMode = A.optionDefaults.channelMode
	end

	if Announcer_Options.debugging ~= nil and Announcer_Options.debug == nil then
		Announcer_Options.debug = Announcer_Options.debugging
	end

	Announcer_Options.taunt = nil
	Announcer_Options.debugging = nil

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end
end

function A.SetOption(optionName, value, showMessage)
	if A.optionDefaults[optionName] == nil then
		return
	end

	Announcer_Options[optionName] = value

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if showMessage ~= false and A.Message then
		A.Message(A.optionLabels[optionName]..": "..A.ColorText(value))
	end
end

function A.ToggleOption(optionName)
	A.SetOption(optionName, not Announcer_Options[optionName])
end

function A.SetAnnounceMode(mode)
	if A.announceModeLabels[mode] == nil then
		return
	end

	Announcer_Options.announceMode = mode

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if A.Message then
		A.Message(A.L.announceMode..": "..A.announceModeLabels[mode])
	end
end

function A.SetChannelMode(mode)
	if A.channelModeLabels[mode] == nil then
		return
	end

	Announcer_Options.channelMode = mode

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if A.Message then
		A.Message(A.L.channelMode..": "..A.channelModeLabels[mode])
	end
end

function A.SetTrackedSpellEnabled(spellKey, value)
	if Announcer_Options.trackedSpells == nil or Announcer_Options.trackedSpells[spellKey] == nil then
		return
	end

	Announcer_Options.trackedSpells[spellKey] = value

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end
end

function A.IsTrackedSpellEnabled(spellDefinition)
	if not spellDefinition then
		return false
	end

	if Announcer_Options.trackedSpells == nil then
		return true
	end

	local optionValue = Announcer_Options.trackedSpells[spellDefinition.key]
	if optionValue == nil then
		return true
	end

	return optionValue
end