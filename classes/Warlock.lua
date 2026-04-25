local A = ValSpams

if not A then
  return
end

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
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 5782
  }
)