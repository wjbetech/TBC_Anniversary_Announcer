local A = ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "shaman_earth_elemental",
    class = "SHAMAN",
    category = "defensive",
    behavior = "cast_success",
    duration = 120,
    spellID = 2062
  }
)

A.RegisterSpellDefinition(
  {
    key = "shaman_fire_elemental",
    class = "SHAMAN",
    category = "offensive",
    behavior = "cast_success",
    duration = 50,
    spellID = 2894
  }
)

A.RegisterSpellDefinition(
  {
    key = "shaman_bloodlust",
    class = "SHAMAN",
    category = "offensive",
    behavior = "cast_success",
    duration = 40,
    spellID = 2825
  }
)

A.RegisterSpellDefinition(
  {
    key = "shaman_heroism",
    class = "SHAMAN",
    category = "offensive",
    behavior = "cast_success",
    duration = 40,
    spellID = 32182
  }
)

A.RegisterSpellDefinition(
  {
    key = "shaman_purge",
    class = "SHAMAN",
    category = "utility",
    behavior = "cast_success",
    flags = {
      dispelOnly = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 370
  }
)

A.RegisterSpellDefinition(
  {
    key = "shaman_earth_shock",
    class = "SHAMAN",
    category = "interrupt",
    behavior = "cast_success",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true,
      interruptOnly = true
    },
    spellID = 8042
  }
)