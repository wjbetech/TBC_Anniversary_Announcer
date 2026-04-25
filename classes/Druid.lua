local A = ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "druid_bash",
    class = "DRUID",
    category = "crowd_control",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 8983
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_cyclone",
    class = "DRUID",
    category = "crowd_control",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 33786
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_growl",
    class = "DRUID",
    category = "taunt",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 6795
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_mangle_bear",
    class = "DRUID",
    category = "important_tank_outcome",
    behavior = "cast_success",
    flags = {
      outcomeOnly = true,
      announceOnMiss = true,
      announceOnDodge = true,
      announceOnParry = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 33878
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_frenzied_regeneration",
    class = "DRUID",
    category = "defensive",
    behavior = "self_aura",
    duration = 10,
    spellID = 22842
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_innervate",
    class = "DRUID",
    category = "utility",
    behavior = "target_aura",
    duration = 20,
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 29166
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_barkskin",
    class = "DRUID",
    category = "defensive",
    behavior = "self_aura",
    duration = 30,
    spellID = 22812
  }
)

A.RegisterSpellDefinition(
  {
    key = "druid_tranquility",
    class = "DRUID",
    category = "defensive",
    behavior = "self_aura",
    duration = 8,
    spellID = 740
  }
)