local A = _G.ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "priest_shackle_undead",
    class = "PRIEST",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 30,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 9484
  }
)

A.RegisterSpellDefinition(
  {
    key = "priest_silence",
    class = "PRIEST",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 5,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 15487
  }
)

A.RegisterSpellDefinition(
  {
    key = "priest_power_infusion",
    class = "PRIEST",
    category = "offensive",
    behavior = "target_aura",
    duration = 15,
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 10060
  }
)

A.RegisterSpellDefinition(
  {
    key = "priest_pain_suppression",
    class = "PRIEST",
    category = "defensive",
    behavior = "target_aura",
    duration = 8,
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 33206
  }
)

A.RegisterSpellDefinition(
  {
    key = "priest_dispel_magic",
    class = "PRIEST",
    category = "utility",
    behavior = "cast_success",
    flags = {
      dispelOnly = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 527
  }
)