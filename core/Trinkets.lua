---@diagnostic disable: undefined-global
local A = _G.ValSpams

A.state.trinketSpells = A.state.trinketSpells or {}

local TRINKET_SLOTS = {
	13,
	14
}

function A.RefreshTrackedTrinkets()
	wipe(A.state.trinketSpells)

	for _, slotID in ipairs(TRINKET_SLOTS) do
		local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then
			local spellName, spellID = GetItemSpell(itemLink)
			if spellName then
				A.state.trinketSpells[spellName] = {
					slotID = slotID,
					spellID = spellID,
					spellName = spellName,
					itemLink = itemLink
				}
			end
		end
	end
end

function A.GetTrackedTrinketDefinition(spellName)
	return A.state.trinketSpells[spellName]
end