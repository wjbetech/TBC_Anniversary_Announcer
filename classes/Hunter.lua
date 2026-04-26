local A = _G.ValSpams

if not A then
	return
end

A.RegisterSpellDefinition({
  key = "hunter_feign_death",
  class = "HUNTER",
  category = "defensive",
  behavior = "cast_success",
  spellID = 5384,
})

A.RegisterSpellDefinition(
  {
    key = "hunter_misdirection",
    class = "HUNTER",
    category = "utility",
    behavior = "target_aura",
    duration = 30,
      flags = {
        announceTarget = true,
        showRaidIcon = true,
        whisperTarget = true
      },
    spellID = 34477,
  }
)

A.RegisterSpellDefinition(
  {
    key = "hunter_intimidation",
    class = "HUNTER",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 3,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 19577
  }
)

A.RegisterSpellDefinition(
  {
    key = "hunter_freezing_trap",
    class = "HUNTER",
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
    spellID = 3355
  }
)