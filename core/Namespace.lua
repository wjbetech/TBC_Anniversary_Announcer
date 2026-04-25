---@diagnostic disable: undefined-global
local addon = _G.ValSpams or _G.Announcer or {}
_G.ValSpams = addon
_G.Announcer = addon

local A = addon

A.name = "ValSpams"
A.locale = GetLocale()
A.state = A.state or {}
A.state.optionCheckboxes = A.state.optionCheckboxes or {}
A.state.categoryCheckboxes = A.state.categoryCheckboxes or {}
A.state.trackedSpellCheckboxes = A.state.trackedSpellCheckboxes or {}
A.state.classPanels = A.state.classPanels or {}
A.state.channelModeDropdown = A.state.channelModeDropdown or nil
A.state.announceModeDropdown = A.state.announceModeDropdown or nil
A.state.ccScopeDropdown = A.state.ccScopeDropdown or nil
A.state.recentBreaks = A.state.recentBreaks or {}

A.classOrder = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"DRUID"
}

A.categoryOrder = {
	"defensive",
	"offensive",
	"taunt",
	"crowd_control",
	"interrupt",
	"important_tank_outcome",
	"utility",
	"trinket"
}

A.announceModeOrder = {
	"cast_only",
	"ending"
}

A.ccScopeOrder = {
	"mine",
	"all_tracked"
}

A.channelModeOrder = {
	"priority",
	"yell_only"
}