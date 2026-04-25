local A = ValSpams

if not A then
  return
end

A.RegisterSpellDefinition(
  {
    key = "mage_polymorph",
    class = "MAGE",
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
    spellID = 118
  }
)

A.RegisterSpellDefinition(
  {
    key = "mage_ice_block",
    class = "MAGE",
    category = "defensive",
    behavior = "self_aura",
    duration = 10,
    spellID = 45438
  }
)

A.RegisterSpellDefinition(
  {
    key = "mage_counterspell",
    class = "MAGE",
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
    spellID = 2139
  }
)

A.RegisterSpellDefinition(
  {
    key = "mage_spellsteal",
    class = "MAGE",
    category = "offensive",
    behavior = "cast_success",
    flags = {
      dispelOnly = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 30449
  }
)
