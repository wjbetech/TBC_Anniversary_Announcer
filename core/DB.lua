---@diagnostic disable: undefined-field
local options = _G.ValSpams_Options or _G.Announcer_Options or {}
_G.ValSpams_Options = options
_G.Announcer_Options = options

local ValSpams_Options = options
local A = _G.ValSpams

A.optionDefaults = {
	announce = true,
	debug = false,
	trackTrinkets = false,
	ccScope = "mine",
	channelMode = "priority",
	announceMode = "ending"
}

A.optionOrder = {
	"announce",
	"trackTrinkets",
	"debug"
}

function A.ShouldDisableInterruptCategory()
	return _G.IsAddOnLoaded and _G.IsAddOnLoaded("ElvUI")
end

function A.SetPref(option, defaultValue)
	if option == nil then
		return defaultValue
	end

	return option
end

function A.GetOptions()
	return ValSpams_Options
end

function A.EnsureCategoryToggles()
	ValSpams_Options.categoryToggles = A.SetPref(ValSpams_Options.categoryToggles, {})

	local validCategories = {}
	for _, category in ipairs(A.categoryOrder) do
		validCategories[category] = true
		local defaultEnabled = true
		if category == "interrupt" and A.ShouldDisableInterruptCategory() then
			defaultEnabled = false
		end
		if ValSpams_Options.categoryToggles[category] == nil then
			ValSpams_Options.categoryToggles[category] = defaultEnabled
		end
	end

	for category in pairs(ValSpams_Options.categoryToggles) do
		if not validCategories[category] then
			ValSpams_Options.categoryToggles[category] = nil
		end
	end
end

function A.EnsureOptions()
	for optionName, defaultValue in pairs(A.optionDefaults) do
		ValSpams_Options[optionName] = A.SetPref(ValSpams_Options[optionName], defaultValue)
	end

	A.EnsureCategoryToggles()

	ValSpams_Options.trackedSpells = A.SetPref(ValSpams_Options.trackedSpells, {})
	local trackedSpellDefinitions = A.GetTrackedSpellDefinitions()
	local validTrackedSpellKeys = {}
	for _, spellDefinition in ipairs(trackedSpellDefinitions) do
		validTrackedSpellKeys[spellDefinition.key] = true
	end

	for spellKey in pairs(ValSpams_Options.trackedSpells) do
		if not validTrackedSpellKeys[spellKey] then
			ValSpams_Options.trackedSpells[spellKey] = nil
		end
	end

	for _, spellDefinition in ipairs(trackedSpellDefinitions) do
		if ValSpams_Options.trackedSpells[spellDefinition.key] == nil then
			ValSpams_Options.trackedSpells[spellDefinition.key] = true
		end
	end


	if A.announceModeLabels[ValSpams_Options.announceMode] == nil then
		ValSpams_Options.announceMode = A.optionDefaults.announceMode
	end

	if A.channelModeLabels[ValSpams_Options.channelMode] == nil then
		ValSpams_Options.channelMode = A.optionDefaults.channelMode
	end

	if A.ccScopeLabels[ValSpams_Options.ccScope] == nil then
		ValSpams_Options.ccScope = A.optionDefaults.ccScope
	end

	if ValSpams_Options.debugging ~= nil and ValSpams_Options.debug == nil then
		ValSpams_Options.debug = ValSpams_Options.debugging
	end

	ValSpams_Options.taunt = nil
	ValSpams_Options.debugging = nil
	ValSpams_Options.showPlayerName = nil
	ValSpams_Options.showTarget = nil
	ValSpams_Options.showRaidIcons = nil
	ValSpams_Options.externalWhispers = nil

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end
end

function A.SetOption(optionName, value, showMessage)
	if A.optionDefaults[optionName] == nil then
		return
	end

	ValSpams_Options[optionName] = value

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if showMessage ~= false and A.Message then
		A.Message(A.optionLabels[optionName]..": "..A.ColorText(value))
	end
end

function A.ToggleOption(optionName)
	A.SetOption(optionName, not ValSpams_Options[optionName])
end

function A.SetAnnounceMode(mode)
	if A.announceModeLabels[mode] == nil then
		return
	end

	ValSpams_Options.announceMode = mode

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

	ValSpams_Options.channelMode = mode

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if A.Message then
		A.Message(A.L.channelMode..": "..A.channelModeLabels[mode])
	end
end

function A.SetCCScope(scope)
	if A.ccScopeLabels[scope] == nil then
		return
	end

	ValSpams_Options.ccScope = scope

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if A.Message then
		A.Message(A.L.ccScope..": "..A.ccScopeLabels[scope])
	end
end

function A.SetCategoryEnabled(category, value)
	if not ValSpams_Options.categoryToggles or ValSpams_Options.categoryToggles[category] == nil then
		return
	end

	if category == "interrupt" and A.ShouldDisableInterruptCategory() then
		value = false
	end

	ValSpams_Options.categoryToggles[category] = value

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end

	if A.Message then
		A.Message(A.categoryLabels[category]..": "..A.ColorText(value))
	end
end

function A.IsCategoryEnabled(category)
	if not category then
		return true
	end

	if category == "interrupt" and A.ShouldDisableInterruptCategory() then
		return false
	end

	if ValSpams_Options.categoryToggles == nil then
		return true
	end

	local optionValue = ValSpams_Options.categoryToggles[category]
	if optionValue == nil then
		return true
	end

	return optionValue
end

function A.SetTrackedSpellEnabled(spellKey, value)
	if ValSpams_Options.trackedSpells == nil or ValSpams_Options.trackedSpells[spellKey] == nil then
		return
	end

	ValSpams_Options.trackedSpells[spellKey] = value

	if A.RefreshOptionsPanel then
		A.RefreshOptionsPanel()
	end
end

function A.IsTrackedSpellEnabled(spellDefinition)
	if not spellDefinition then
		return false
	end

	if ValSpams_Options.trackedSpells == nil then
		return true
	end

	local optionValue = ValSpams_Options.trackedSpells[spellDefinition.key]
	if optionValue == nil then
		return true
	end

	return optionValue
end