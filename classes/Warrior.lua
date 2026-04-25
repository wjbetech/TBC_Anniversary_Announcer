local A = ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "warrior_pummel",
    class = "WARRIOR",
    category = "interrupt",
    behavior = "cast_success",
    flags = {
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 6552
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_concussion_blow",
    class = "WARRIOR",
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
    spellID = 12809
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_disarm",
    class = "WARRIOR",
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
    spellID = 676
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_mocking_blow",
    class = "WARRIOR",
    category = "taunt",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 694
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_taunt",
    class = "WARRIOR",
    category = "taunt",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 355
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_devastate",
    class = "WARRIOR",
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
    spellID = 20243
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_shield_slam",
    class = "WARRIOR",
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
    spellID = 23922
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_last_stand",
    class = "WARRIOR",
    category = "defensive",
    behavior = "self_aura",
    duration = 20,
    flags = { announceOnExpire = true },
    spellID = 12975,
  }
)

A.RegisterSpellDefinition(
  {
    key = "warrior_shield_wall",
    class = "WARRIOR",
    category = "defensive",
    behavior = "self_aura",
    duration = 10,
    flags = {
      announceOnExpire = true
    },
    spellID = 871,
  }
)