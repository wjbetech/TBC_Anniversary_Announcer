---@diagnostic disable: undefined-global
local A = Announcer
local trackedAuraTimers = A.state.trackedAuraTimers

function A.GetCombatLogContext()
  -- don't reformat that, Lua linter is a pain
  local timestamp, combatEvent,
  hideCaster, sourceGUID,
  sourceName, sourceFlags,
  sourceRaidFlags, destGUID,
  destName, destFlags,
  destRaidFlags, extraArg1,
  extraArg2, extraArg3,
  extraArg4
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
    extraArg3 = extraArg3,
    extraArg4 = extraArg4
  }
end

function A.HandleSourceCombatEvent(context, playerGUID)
  if context.sourceGUID ~= playerGUID then
    return nil
  end

  local castSuccessDefinition = A.GetBehaviorDefinition("cast_success", context.extraArg2)
  local targetAuraDefinition = A.GetBehaviorDefinition("target_aura", context.extraArg2)

  -- handle spell misses (maybe immunes and resists here too)
  if context.combatEvent == "SPELL_MISSED"
  then
    local missedDefinition = castSuccessDefinition
    or targetAuraDefinition

    local missType = context.extraArg4 -- miss type (miss, dodge, resist, immune, etc)

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
        context.extraArg1,
        context.extraArg2,
        context.destName,
        context.extraArg4 -- miss type (miss, dodge, resist, immune, etc)
      )
    end
  end

  if context.combatEvent == "SPELL_INTERRUPT"
  and castSuccessDefinition
  then
    return A.FormatCastMessage(
      context.sourceName,
      context.extraArg1,
      context.extraArg2,
      context.destName,
      nil,
      true -- isInterrupt
    )
  end

  -- this should refer to successful casts
  -- and ensure only true interrupts are announced
  if context.combatEvent == "SPELL_CAST_SUCCESS"
  and castSuccessDefinition
  then

    -- don't announce interrupts on non-interruptables
    if castSuccessDefinition.flags.interruptOnly
    then
      return nil
    end

    return A.FormatCastMessage(
      context.sourceName,
      context.extraArg1,
      context.extraArg2,
      context.destName,
      castSuccessDefinition.duration
    )
  end

  -- this should refer to target-aura checks
  if (context.combatEvent == "SPELL_AURA_APPLIED"
  or context.combatEvent == "SPELL_AURA_REFRESH")
  and targetAuraDefinition
  then

    if context.combatEvent == "SPELL_AURA_REFRESH"
    and targetAuraDefinition
    then
      A.ClearTrackedAuraTimers(context.extraArg2, context.extraArg1, context.destGUID)
    end

    if Announcer_Options.announceMode == "countdown" then
      A.ScheduleTrackedAuraCountdown(
        context.sourceName,
        context.extraArg2,
        context.extraArg1,
        context.destName,
        context.destGUID,
        targetAuraDefinition.duration
      )
    end

    return A.FormatCastMessage(
      context.sourceName,
      context.extraArg1,
      context.extraArg2,
      context.destName,
      targetAuraDefinition.duration
    )
  end

  -- this should refer to removals of auras (natural and unnatural)
  if context.combatEvent == "SPELL_AURA_REMOVED"
  and targetAuraDefinition
  then
    A.ClearTrackedAuraTimers(context.extraArg2, context.extraArg1, context.destGUID)

    if Announcer_Options.announceMode == "ending" then
      return A.FormatEndedMessage(
        context.sourceName,
        context.extraArg1,
        context.extraArg2,
        context.destName
      )
    end
  end

  return nil
end

function A.HandleDestCombatEvent(context, playerGUID)
  if context.destGUID ~= playerGUID then
    return nil
  end

  local selfAuraDefinition = A.GetBehaviorDefinition("self_aura", context.extraArg2)

  if (context.combatEvent == "SPELL_AURA_APPLIED"
  or context.combatEvent == "SPELL_AURA_REFRESH")
  and selfAuraDefinition
  then
    if context.combatEvent == "SPELL_AURA_REFRESH" then
      A.ClearTrackedAuraTimers(context.extraArg2, context.extraArg1, context.destGUID)
    end

    if Announcer_Options.announceMode == "countdown" then
      A.ScheduleTrackedAuraCountdown(
        context.sourceName,
        context.extraArg2,
        context.extraArg1,
        nil,
        context.destGUID,
        selfAuraDefinition.duration
      )
    end

    return A.FormatCastMessage(
      context.sourceName,
      context.extraArg1,
      context.extraArg2,
      nil,
      selfAuraDefinition.duration
    )
  end

  if context.combatEvent == "SPELL_AURA_REMOVED"
  and selfAuraDefinition
  then
    A.ClearTrackedAuraTimers(context.extraArg2, context.extraArg1, context.destGUID)

    if Announcer_Options.announceMode == "ending" then
      return A.FormatEndedMessage(
        context.sourceName,
        context.extraArg1,
        context.extraArg2,
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
    return
  end

  if event == "PLAYER_EQUIPMENT_CHANGED" then
    return
  end

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    A.HandleCombatLogEvent()
    return
  end
end
