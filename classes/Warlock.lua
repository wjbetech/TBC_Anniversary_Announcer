local A = Announcer

A.RegisterSpellDefinition(
 {
  key = "warlock_soulstone",
  class = "WARLOCK",
  category = "utility",
  behavior = "target_aura",
  flags = {
    announceTarget = true,
    showRaidIcon = true,
    whisperTarget = true
  },
  spellID = 20707
 }
)

A.RegisterSpellDefinition(
  {
    key = "warlock_fear",
    class = "WARLOCK",
    category = "crowd_control",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 5782
  }
)

if not A then
	return
end