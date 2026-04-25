---@diagnostic disable: undefined-global
local A = ValSpams

A.registry = {
	self_aura = {},
	target_aura = {},
	cast_success = {},
	classSpellDefinitions = {},
	allSpellDefinitions = {}
}

for _, classToken in ipairs(A.classOrder) do
	A.registry.classSpellDefinitions[classToken] = {}
end

function A.RegisterSpellDefinition(spellDefinition)

  if not spellDefinition.category or not spellDefinition.behavior then
    return
  end

  if not spellDefinition.key or not spellDefinition.class or not spellDefinition.spellID then
    return
  end

	local registryGroup = A.registry[spellDefinition.behavior]
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
    category = spellDefinition.category,
    behavior = spellDefinition.behavior,
		spellID = spellDefinition.spellID,
		duration = spellDefinition.duration,
    flags = spellDefinition.flags or {},
		spellName = spellName
	}

	registryGroup[spellDefinition.spellID] = storedDefinition
	A.registry.classSpellDefinitions[storedDefinition.class] =
		A.registry.classSpellDefinitions[storedDefinition.class] or {}
	table.insert(
		A.registry.classSpellDefinitions[storedDefinition.class],
		storedDefinition
	)
	table.insert(A.registry.allSpellDefinitions, storedDefinition)
end

function A.GetBehaviorDefinition(behavior, spellID)
  if A.registry[behavior] == nil then
    return nil
  end

	return A.registry[behavior][spellID]
end

function A.GetTrackedSpellDefinitions()
	return A.registry.allSpellDefinitions
end

function A.GetClassSpellDefinitions(classToken)
	return A.registry.classSpellDefinitions[classToken] or {}
end
