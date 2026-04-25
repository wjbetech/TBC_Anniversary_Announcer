local A = ValSpams

if not A then
	return
end

A.RegisterSpellDefinition(
  {
    key = "paladin_hammer_of_justice",
    class = "PALADIN",
    category = "crowd_control",
    behavior = "target_aura",
    duration = 6,
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceOnBreak = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 853
  }
)


A.RegisterSpellDefinition(
  {
    key = "paladin_blessing_of_protection",
    class = "PALADIN",
    category = "defensive",
    behavior = "target_aura",
    duration = 10,
      flags = {
        announceTarget = true,
        showRaidIcon = true,
        whisperTarget = true
      },
    spellID = 1022
  }
)


A.RegisterSpellDefinition(
  {
    key = "paladin_blessing_of_freedom",
    class = "PALADIN",
    category = "defensive",
    behavior = "target_aura",
    duration = 14,
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 1044
  }
)


A.RegisterSpellDefinition(
  {
    key = "paladin_blessing_of_sacrifice",
    class = "PALADIN",
    category = "defensive",
    behavior = "target_aura",
    duration = 30,
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 6940
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_cleanse",
    class = "PALADIN",
    category = "utility",
    behavior = "cast_success",
    flags = {
      dispelOnly = true,
      announceOnResist = true,
      announceOnImmune = true,
      announceTarget = true,
      showRaidIcon = true
    },
    spellID = 4987
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_righteous_defense",
    class = "PALADIN",
    category = "taunt",
    behavior = "target_aura",
    flags = {
      announceOnMiss = true,
      announceOnResist = true,
      announceOnImmune = true,
	      announceTarget = true,
	      showRaidIcon = true
    },
    spellID = 31789
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_divine_shield",
    class = "PALADIN",
    category = "defensive",
    behavior = "self_aura",
    duration = 8,
    spellID = 642
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_divine_illumination",
    class = "PALADIN",
    category = "utility",
    behavior = "self_aura",
    duration = 15,
    spellID = 31842
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_avenging_wrath",
    class = "PALADIN",
    category = "offensive",
    behavior = "self_aura",
    duration = 20,
    spellID = 31884
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_judgement",
    class = "PALADIN",
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
    spellID = 20271
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_avengers_shield",
    class = "PALADIN",
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
    spellID = 31935
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_exorcism",
    class = "PALADIN",
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
    spellID = 879
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_divine_intervention",
    class = "PALADIN",
    category = "utility",
    behavior = "target_aura",
    flags = {
      announceTarget = true,
      showRaidIcon = true,
      whisperTarget = true
    },
    spellID = 19752
  }
)

A.RegisterSpellDefinition(
  {
    key = "paladin_lay_on_hands",
    class = "PALADIN",
    category = "defensive",
    behavior = "cast_success",
    flags = {
      announceTarget = true,
	  showRaidIcon = true,
	  whisperTarget = true
    },
    spellID = 633
  }
)