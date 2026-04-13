local A = Announcer

A.registry = {
	hit = {},
	tracked_aura = {},
	cooldown = {},
	classSpellDefinitions = {},
	allSpellDefinitions = {}
}

for _, classToken in ipairs(A.classOrder) do
	A.registry.classSpellDefinitions[classToken] = {}
end

function A.RegisterSpellDefinition(spellDefinition)
	local registryGroup = A.registry[spellDefinition.group]
	if registryGroup == nil then
		return
	end

	local spellName = GetSpellInfo(spellDefinition.spellID)
	if not spellName then
		return
	end

	local storedDefinition = {
		key = spellDefinition.key,
		class = spellDefinition.class,
		group = spellDefinition.group,
		spellID = spellDefinition.spellID,
		duration = spellDefinition.duration,
		spellName = spellName
	}

	registryGroup[spellName] = storedDefinition
	A.registry.classSpellDefinitions[storedDefinition.class] = A.registry.classSpellDefinitions[storedDefinition.class] or {}
	table.insert(A.registry.classSpellDefinitions[storedDefinition.class], storedDefinition)
	table.insert(A.registry.allSpellDefinitions, storedDefinition)
end

function A.GetTrackedSpellDefinitions()
	return A.registry.allSpellDefinitions
end

function A.GetClassSpellDefinitions(classToken)
	return A.registry.classSpellDefinitions[classToken] or {}
end

function A.GetHitDefinition(spellName)
	return A.registry.hit[spellName]
end

function A.GetTrackedAuraDefinition(spellName)
	return A.registry.tracked_aura[spellName]
end

function A.GetCooldownDefinition(spellName)
	return A.registry.cooldown[spellName]
end