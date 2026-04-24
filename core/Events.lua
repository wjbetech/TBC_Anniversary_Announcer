---@diagnostic disable: undefined-global
local A = Announcer

local RAID_ICON_FLAGS = {
  { mask = 0x00100000, text = "{star}" },
  { mask = 0x00200000, text = "{circle}" },
  { mask = 0x00400000, text = "{diamond}" },
  { mask = 0x00800000, text = "{triangle}" },
  { mask = 0x01000000, text = "{moon}" },
  { mask = 0x02000000, text = "{square}" },
  { mask = 0x04000000, text = "{cross}" },
  { mask = 0x08000000, text = "{skull}" },
}

function A.GetRaidIconText(raidFlags)
  if not raidFlags or raidFlags == 0 or not bit or not bit.band then
    return nil
  end

  for _, raidIcon in ipairs(RAID_ICON_FLAGS) do
    if bit.band(raidFlags, raidIcon.mask) ~= 0 then
      return raidIcon.text
    end
  end

  return nil
end

function A.GetAnnounceTarget(definition, destName, destRaidFlags)
  if not definition or not definition.flags or not definition.flags.announceTarget then
    return nil
  end

  local announcedTarget = destName
  if definition.flags.showRaidIcon then
    local raidIconText = A.GetRaidIconText(destRaidFlags)
    if raidIconText then
      if announcedTarget and announcedTarget ~= "" then
        announcedTarget = announcedTarget.." "..raidIconText
      else
        announcedTarget = raidIconText
      end
    end
  end

  return announcedTarget
end

  function A.TryWhisperTarget(definition, context, message)
    if not definition or not definition.flags or not definition.flags.whisperTarget then
      return
    end

    if not Announcer_Options.externalWhispers then
      return
    end

    if not context.destName or context.destName == "" or context.destGUID == UnitGUID("player") then
      return
    end

    SendChatMessage(message, "WHISPER", nil, context.destName)
  end
function A.GetCombatLogContext()
  -- don't reformat that, Lua linter is a pain
  local timestamp, combatEvent,
  hideCaster, sourceGUID,
  sourceName, sourceFlags,
  sourceRaidFlags, destGUID,
  destName, destFlags,
  destRaidFlags, extraArg1,
  extraArg2, spellSchool,
  extraArg4, extraArg5, extraArg6
  = CombatLogGetCurrentEventInfo()

  -- direct map of combat log event info from above
  return {
    timestamp = timestamp,
    combatEvent = combatEvent,
    hideCaster = hideCaster,
    sourceGUID = sourceGUID,
    sourceName = sourceName,
    sourceFlags = sourceFlags,
    sourceRaidFlags = sourceRaidFlags,
    destGUID = destGUID,
    destName = destName,
    destFlags = destFlags,
    destRaidFlags = destRaidFlags,
    spellID = extraArg1,
    spellName = extraArg2,
    spellSchool = spellSchool,
    eventArg1 = extraArg4,
    eventArg2 = extraArg5,
    eventArg3 = extraArg6
  }
end

function A.HandleSourceCombatEvent(context, playerGUID)
  if context.sourceGUID ~= playerGUID then
    return nil
  end

  local castSuccessDefinition = A.GetBehaviorDefinition("cast_success", context.spellName)
  local targetAuraDefinition = A.GetBehaviorDefinition("target_aura", context.spellName)
  local trinketDefinition = A.GetTrackedTrinketDefinition(context.spellName)

  -- handle spell misses (maybe immunes and resists here too)
  if context.combatEvent == "SPELL_MISSED"
  then

    local missedDefinition = castSuccessDefinition
    or targetAuraDefinition
    local announceTarget = A.GetAnnounceTarget(missedDefinition, context.destName, context.destRaidFlags)

    if not missedDefinition then
      return nil
    end

    local missType = context.eventArg1 -- miss type (miss, dodge, resist, immune, etc)

    if missType == "MISS"
    and not missedDefinition.flags.announceOnMiss
    then
      return nil
    end

    if missType == "DODGE"
    and not missedDefinition.flags.announceOnDodge
    then
      return nil
    end

    if missType == "PARRY"
    and not missedDefinition.flags.announceOnParry
    then
      return nil
    end

    if missType == "RESIST"
    and not missedDefinition.flags.announceOnResist
    then
      return nil
    end

    if missType == "IMMUNE"
    and not missedDefinition.flags.announceOnImmune
    then
      return nil
    end

    if missedDefinition
    then
      return A.FormatMissMessage(
        context.sourceName,
        context.spellID,
        context.spellName,
        announceTarget,
        missType -- miss type (miss, dodge, resist, immune, etc)
      )
    end
  end

  if context.combatEvent == "SPELL_INTERRUPT"
  and castSuccessDefinition
  then
    local interruptedSpellID = context.eventArg1
    local interruptedSpellName = context.eventArg2
    local announceTarget = A.GetAnnounceTarget(castSuccessDefinition, context.destName, context.destRaidFlags)

    if castSuccessDefinition.category ~= "interrupt" and
    not castSuccessDefinition.flags.interruptOnly
    then
      return nil
    end

    return A.FormatInterruptMessage(
      context.sourceName,
      announceTarget,
      interruptedSpellID,
      interruptedSpellName
    )
  end

  -- this should refer to successful casts
  -- and ensure only true interrupts are announced
  if context.combatEvent == "SPELL_CAST_SUCCESS"
  and castSuccessDefinition
  then
    local announceTarget = A.GetAnnounceTarget(castSuccessDefinition, context.destName, context.destRaidFlags)

    -- don't announce interrupts on non-interruptables
    if castSuccessDefinition.flags.interruptOnly
    then
      return nil
    end

    local eventMessage = A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      announceTarget,
      castSuccessDefinition.duration
    )

    A.TryWhisperTarget(castSuccessDefinition, context, eventMessage)
    return eventMessage
  end

  if context.combatEvent == "SPELL_CAST_SUCCESS"
  and Announcer_Options.trackTrinkets
  and trinketDefinition
  then
    return A.FormatCastMessage(
      context.sourceName,
      context.spellID or trinketDefinition.spellID,
      context.spellName or trinketDefinition.spellName,
      nil,
      nil
    )
  end

  -- this should refer to target-aura checks
  if context.combatEvent == "SPELL_AURA_APPLIED"
  and targetAuraDefinition
  then
    local announceTarget = A.GetAnnounceTarget(targetAuraDefinition, context.destName, context.destRaidFlags)

    local eventMessage = A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      announceTarget,
      targetAuraDefinition.duration
    )

    A.TryWhisperTarget(targetAuraDefinition, context, eventMessage)
    return eventMessage
  end

  -- this should refer to removals of auras (natural and unnatural)
  if context.combatEvent == "SPELL_AURA_REMOVED"
  and targetAuraDefinition
  then
    local announceTarget = A.GetAnnounceTarget(targetAuraDefinition, context.destName, context.destRaidFlags)

    if Announcer_Options.announceMode == "ending" then
      return A.FormatEndedMessage(
        context.sourceName,
        context.spellID,
        context.spellName,
        announceTarget
      )
    end
  end

  return nil
end

function A.HandleDestCombatEvent(context, playerGUID)
  if context.destGUID ~= playerGUID then
    return nil
  end

  local selfAuraDefinition = A.GetBehaviorDefinition("self_aura", context.spellName)

  if context.combatEvent == "SPELL_AURA_APPLIED"
  and selfAuraDefinition
  then
    return A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      nil,
      selfAuraDefinition.duration
    )
  end

  if context.combatEvent == "SPELL_AURA_REMOVED"
  and selfAuraDefinition
  then
    if Announcer_Options.announceMode == "ending" then
      return A.FormatEndedMessage(
        context.sourceName,
        context.spellID,
        context.spellName,
        nil
      )
    end
  end

  return nil
end


function A.HandleCombatLogEvent()
  local context = A.GetCombatLogContext()
  local playerGUID = UnitGUID("player")

  if context.sourceGUID ~= playerGUID and context.destGUID ~= playerGUID then
    return
  end

  local eventMessage = A.HandleSourceCombatEvent(context, playerGUID)

  if eventMessage == nil then
    eventMessage = A.HandleDestCombatEvent(context, playerGUID)
  end

  A.BroadcastMessage(eventMessage)
end

function A.OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
		A.RefreshTrackedTrinkets()
    return
  end

  if event == "PLAYER_EQUIPMENT_CHANGED" then
		local slotID = ...
		if slotID == 13 or slotID == 14 then
			A.RefreshTrackedTrinkets()
		end
    return
  end

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    A.HandleCombatLogEvent()
    return
  end
end
