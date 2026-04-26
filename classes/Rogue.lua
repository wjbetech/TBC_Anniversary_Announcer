local A = _G.ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "rogue_sap",
    class = "ROGUE",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 45,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 6770
  }
)

A.RegisterSpellDefinition(
  {
    key = "rogue_kidney_shot",
    class = "ROGUE",
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
    spellID = 408
  }
)

A.RegisterSpellDefinition(
  {
    key = "rogue_evasion",
    class = "ROGUE",
    category = "defensive",
    behavior = "self_aura",
    duration = 15,
    spellID = 26669
  }
)

A.RegisterSpellDefinition(
  {
    key = "rogue_cheap_shot",
    class = "ROGUE",
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
    spellID = 1833
  }
)

A.RegisterSpellDefinition(
  {
    key = "rogue_blind",
    class = "ROGUE",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 10,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 2094
  }
)

A.RegisterSpellDefinition(
  {
    key = "rogue_kick",
    class = "ROGUE",
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
    spellID = 1766
  }
)