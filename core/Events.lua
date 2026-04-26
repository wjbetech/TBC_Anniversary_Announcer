---@diagnostic disable: undefined-global, undefined-field
local A = _G.ValSpams
local ValSpams_Options = _G.ValSpams_Options

local RAID_ICON_FLAGS = {
  { mask = 0x00100000, text = "{rt1}" },
  { mask = 0x00200000, text = "{rt2}" },
  { mask = 0x00400000, text = "{rt3}" },
  { mask = 0x00800000, text = "{rt4}" },
  { mask = 0x01000000, text = "{rt5}" },
  { mask = 0x02000000, text = "{rt6}" },
  { mask = 0x04000000, text = "{rt7}" },
  { mask = 0x08000000, text = "{rt8}" },
}

local RAID_ICON_INDEX_TEXT = {
  [1] = "{rt1}",
  [2] = "{rt2}",
  [3] = "{rt3}",
  [4] = "{rt4}",
  [5] = "{rt5}",
  [6] = "{rt6}",
  [7] = "{rt7}",
  [8] = "{rt8}",
}

function A.GetRaidIconText(raidFlags)
  if not raidFlags or raidFlags == 0 then
    return nil
  end

  for _, raidIcon in ipairs(RAID_ICON_FLAGS) do
    local iconBand = raidFlags % (raidIcon.mask * 2)
    if iconBand >= raidIcon.mask then
      return raidIcon.text
    end
  end

  return nil
end

function A.ShouldAnnounceDefinition(definition)
  if not definition then
    return false
  end

  if not A.IsTrackedSpellEnabled(definition) then
    return false
  end

  if not A.IsCategoryEnabled(definition.category) then
    return false
  end

  return true
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
        announcedTarget = raidIconText..announcedTarget
      else
        announcedTarget = raidIconText
      end
    end
  end

  return announcedTarget
end

function A.GetCurrentTargetRaidIconText(context)
  if not _G.UnitExists("target") then
    return nil
  end

  local targetName = UnitName("target")
  local targetGUID = UnitGUID("target")
  local namesMatch = targetName and context.destName and targetName == context.destName
  local guidsMatch = targetGUID and context.destGUID and targetGUID == context.destGUID
  if not namesMatch and not guidsMatch then
    return nil
  end

  return RAID_ICON_INDEX_TEXT[_G.GetRaidTargetIndex("target") or 0]
end

function A.GetContextAnnounceTarget(definition, context, allowCurrentTargetFallback)
  local announcedTarget = A.GetAnnounceTarget(definition, context.destName, context.destRaidFlags)
  local currentTargetRaidIconText = nil
  if allowCurrentTargetFallback and definition and definition.flags and definition.flags.showRaidIcon then
    currentTargetRaidIconText = A.GetCurrentTargetRaidIconText(context)
    if currentTargetRaidIconText and announcedTarget and context.destName and announcedTarget == context.destName then
      return currentTargetRaidIconText..announcedTarget
    end
  end

  if announcedTarget or not allowCurrentTargetFallback then
    return announcedTarget
  end

  if not definition or definition.category ~= "crowd_control" then
    return nil
  end

  if not _G.UnitExists("target") then
    return nil
  end

  local targetName = UnitName("target")
  if not targetName or targetName == "" then
    return nil
  end

  if currentTargetRaidIconText then
    return currentTargetRaidIconText..targetName
  end

  return targetName
end

function A.TryWhisperTarget(definition, context, message)
  if not definition or not definition.flags or not definition.flags.whisperTarget then
    return
  end

  if not message or message == "" then
    return
  end

  if not context.destName or context.destName == "" or context.destGUID == UnitGUID("player") then
    return
  end

  SendChatMessage(message, "WHISPER", nil, context.destName)
end

function A.GetCombatLogContext()
  local timestamp, combatEvent,
  hideCaster, sourceGUID,
  sourceName, sourceFlags,
  sourceRaidFlags, destGUID,
  destName, destFlags,
  destRaidFlags, extraArg1,
  extraArg2, spellSchool,
  extraArg4, extraArg5, extraArg6
  = CombatLogGetCurrentEventInfo()

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

function A.MarkRecentBreak(context)
  local key = (context.destGUID or "")..":"..(context.spellName or "")
  A.state.recentBreaks[key] = context.timestamp or 0
end

function A.GetCrowdControlKey(context)
  local spellToken = context.spellID or context.spellName or ""
  return (context.destGUID or "")..":"..tostring(spellToken)
end

function A.GetAnnouncedTargetAuraKey(context)
  local spellToken = context.spellID or context.spellName or ""
  local destToken = context.destGUID or context.destName or ""
  return tostring(spellToken)..":"..tostring(destToken)
end

function A.MarkRecentTargetAuraAnnouncement(context)
  A.state.recentBreaks["announce:"..A.GetAnnouncedTargetAuraKey(context)] = context.timestamp or 0
end

function A.WasRecentlyAnnouncedTargetAura(context)
  local key = "announce:"..A.GetAnnouncedTargetAuraKey(context)
  local announcedAt = A.state.recentBreaks[key]
  if not announcedAt then
    return false
  end

  local eventTime = context.timestamp or 0
  if (eventTime - announcedAt) <= 0.5 then
    return true
  end

  A.state.recentBreaks[key] = nil
  return false
end

function A.SetActiveCrowdControlOwner(context, ownerGUID)
  if not ownerGUID or ownerGUID == "" then
    return
  end

  A.state.activeCrowdControlOwners[A.GetCrowdControlKey(context)] = ownerGUID
end

function A.GetActiveCrowdControlOwner(context)
  return A.state.activeCrowdControlOwners[A.GetCrowdControlKey(context)]
end

function A.ClearActiveCrowdControlOwner(context)
  A.state.activeCrowdControlOwners[A.GetCrowdControlKey(context)] = nil
end

function A.WasRecentlyBroken(context)
  local key = (context.destGUID or "")..":"..(context.spellName or "")
  local brokenAt = A.state.recentBreaks[key]
  if not brokenAt then
    return false
  end

  local eventTime = context.timestamp or 0
  A.state.recentBreaks[key] = nil
  return (eventTime - brokenAt) <= 0.5
end

function A.IsPlayerGUID(unitGUID)
  return type(unitGUID) == "string" and string.find(unitGUID, "^Player%-") ~= nil
end

function A.IsPlayerSource(context, playerGUID, playerName)
  if context.sourceGUID and playerGUID and context.sourceGUID == playerGUID then
    return true
  end

  return playerName ~= nil
    and playerName ~= ""
    and context.sourceName ~= nil
    and context.sourceName == playerName
end

function A.ShouldAnnounceCrowdControlOutcome(context, playerGUID, allowExternalCrowdControl)
  local ownerGUID = A.GetActiveCrowdControlOwner(context)
  if ownerGUID then
    return ownerGUID == playerGUID or allowExternalCrowdControl
  end

  if not allowExternalCrowdControl then
    return false
  end

  if context.sourceGUID == playerGUID then
    return true
  end

  return allowExternalCrowdControl and context.sourceGUID ~= nil
end

function A.ShouldHandleTrackedCrowdControl(context)
  if ValSpams_Options.ccScope ~= "all_tracked" then
    return false
  end

  local definition = A.GetBehaviorDefinition("target_aura", context.spellID)
  if not A.ShouldAnnounceDefinition(definition) then
    return false
  end

  return definition.category == "crowd_control"
end

function A.HandleMissedDefinition(context, definition)
  if not definition then
    return nil
  end

  local missType = context.eventArg1
  if missType == "MISS" and not definition.flags.announceOnMiss then
    return nil
  end

  if missType == "DODGE" and not definition.flags.announceOnDodge then
    return nil
  end

  if missType == "PARRY" and not definition.flags.announceOnParry then
    return nil
  end

  if missType == "RESIST" and not definition.flags.announceOnResist then
    return nil
  end

  if missType == "IMMUNE" and not definition.flags.announceOnImmune then
    return nil
  end

  if definition.category == "important_tank_outcome" then
    return A.FormatTankMissMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      A.GetAnnounceTarget(definition, context.destName, context.destRaidFlags),
      missType
    )
  end

  return A.FormatMissMessage(
    context.sourceName,
    context.spellID,
    context.spellName,
    A.GetAnnounceTarget(definition, context.destName, context.destRaidFlags),
    missType
  )
end

function A.HandleSourceCombatEvent(context, playerGUID, allowExternalCrowdControl)
  local sourceIsPlayer = A.IsPlayerSource(context, playerGUID, UnitName("player"))
  local castSuccessDefinition = A.GetBehaviorDefinition("cast_success", context.spellID)
  local targetAuraDefinition = A.GetBehaviorDefinition("target_aura", context.spellID)
  local trinketDefinition = A.GetTrackedTrinketDefinition(context.spellName)
  local trackedTrinketSuccess = context.combatEvent == "SPELL_CAST_SUCCESS" and trinketDefinition ~= nil

  if not sourceIsPlayer and not trackedTrinketSuccess then
    if not allowExternalCrowdControl then
      return nil
    end
    castSuccessDefinition = nil
  end

  if not A.ShouldAnnounceDefinition(castSuccessDefinition) then
    castSuccessDefinition = nil
  end

  if not A.ShouldAnnounceDefinition(targetAuraDefinition) then
    targetAuraDefinition = nil
  end

  if context.combatEvent == "SPELL_MISSED" then
    return A.HandleMissedDefinition(context, castSuccessDefinition or targetAuraDefinition)
  end

  if context.combatEvent == "SPELL_DISPEL" and castSuccessDefinition and castSuccessDefinition.flags.dispelOnly then
    if A.IsPlayerGUID(context.destGUID) then
      return nil
    end

    return A.FormatDispelMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      A.GetAnnounceTarget(castSuccessDefinition, context.destName, context.destRaidFlags),
      context.eventArg1,
      context.eventArg2
    )
  end

  if context.combatEvent == "SPELL_INTERRUPT" and castSuccessDefinition then
    if castSuccessDefinition.category ~= "interrupt" and not castSuccessDefinition.flags.interruptOnly then
      return nil
    end

    return A.FormatInterruptMessage(
      context.sourceName,
      A.GetAnnounceTarget(castSuccessDefinition, context.destName, context.destRaidFlags),
      context.eventArg1,
      context.eventArg2
    )
  end

  if context.combatEvent == "SPELL_CAST_SUCCESS" and castSuccessDefinition then
    if castSuccessDefinition.flags.interruptOnly
    or castSuccessDefinition.flags.outcomeOnly
    or castSuccessDefinition.flags.dispelOnly
    then
      return nil
    end

      local announceTarget = A.GetContextAnnounceTarget(castSuccessDefinition, context, sourceIsPlayer)
      local castDuration = castSuccessDefinition.duration
      local isCrowdControl = castSuccessDefinition.category == "crowd_control"

    local eventMessage = A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
        announceTarget,
        castDuration,
        false,
        isCrowdControl,
        isCrowdControl and announceTarget or nil
    )

    A.TryWhisperTarget(
      castSuccessDefinition,
      context,
      A.FormatWhisperCastMessage(
        context.sourceName,
        context.spellID,
        context.spellName,
          announceTarget,
          castDuration
      )
    )
    return eventMessage
  end

  if context.combatEvent == "SPELL_CAST_SUCCESS" and sourceIsPlayer and targetAuraDefinition then
    if targetAuraDefinition.category == "crowd_control" then
      A.SetActiveCrowdControlOwner(context, playerGUID)
    end

    A.MarkRecentTargetAuraAnnouncement(context)

    return A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      A.GetContextAnnounceTarget(targetAuraDefinition, context, true),
      targetAuraDefinition.duration,
      false,
      targetAuraDefinition.category == "crowd_control",
      targetAuraDefinition.category == "crowd_control"
        and A.GetContextAnnounceTarget(targetAuraDefinition, context, true)
        or nil
    )
  end

  if context.combatEvent == "SPELL_CAST_SUCCESS"
  and A.IsCategoryEnabled("trinket")
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

  if context.combatEvent == "SPELL_AURA_APPLIED" and targetAuraDefinition then
    if sourceIsPlayer == false and not allowExternalCrowdControl then
      local sourceName = context.sourceName
      if not sourceName or sourceName ~= UnitName("player") then
        return nil
      end
    end

    if A.WasRecentlyAnnouncedTargetAura(context) then
      return nil
    end

    local announceTarget = A.GetContextAnnounceTarget(targetAuraDefinition, context, sourceIsPlayer)
    local castDuration = targetAuraDefinition.duration
    local isCrowdControl = targetAuraDefinition.category == "crowd_control"

    if isCrowdControl and (sourceIsPlayer or allowExternalCrowdControl) then
      A.SetActiveCrowdControlOwner(context, context.sourceGUID)
    end

    local eventMessage = A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      announceTarget,
      castDuration,
      false,
      isCrowdControl,
      isCrowdControl and announceTarget or nil
    )

    A.TryWhisperTarget(
      targetAuraDefinition,
      context,
      A.FormatWhisperCastMessage(
        context.sourceName,
        context.spellID,
        context.spellName,
        announceTarget,
        castDuration
      )
    )
    return eventMessage
  end

  if (context.combatEvent == "SPELL_AURA_BROKEN"
  or context.combatEvent == "SPELL_AURA_BROKEN_SPELL")
  and targetAuraDefinition
  then
    if targetAuraDefinition.category ~= "crowd_control" or not targetAuraDefinition.flags.announceOnBreak then
      return nil
    end

    if not A.ShouldAnnounceCrowdControlOutcome(context, playerGUID, allowExternalCrowdControl) then
      return nil
    end

    A.MarkRecentBreak(context)
    A.ClearActiveCrowdControlOwner(context)
    return A.FormatBreakMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      A.GetAnnounceTarget(targetAuraDefinition, context.destName, context.destRaidFlags)
    )
  end

  if context.combatEvent == "SPELL_AURA_REMOVED" and targetAuraDefinition then
    if targetAuraDefinition.category == "crowd_control" then
      local shouldAnnounce = A.ShouldAnnounceCrowdControlOutcome(context, playerGUID, allowExternalCrowdControl)
      A.ClearActiveCrowdControlOwner(context)

      if not shouldAnnounce then
        return nil
      end

      if A.WasRecentlyBroken(context) then
        return nil
      end
    end

    if targetAuraDefinition.category == "taunt" then
      return nil
    end

    if targetAuraDefinition.flags.announceOnExpire == false or ValSpams_Options.announceMode ~= "ending" then
      return nil
    end

    return A.FormatEndedMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      A.GetAnnounceTarget(targetAuraDefinition, context.destName, context.destRaidFlags)
    )
  end

  return nil
end

function A.HandleDestCombatEvent(context, playerGUID)
  if context.destGUID ~= playerGUID then
    return nil
  end

  local selfAuraDefinition = A.GetBehaviorDefinition("self_aura", context.spellID)
  if not A.ShouldAnnounceDefinition(selfAuraDefinition) then
    selfAuraDefinition = nil
  end

  if context.combatEvent == "SPELL_AURA_APPLIED" and selfAuraDefinition then
    return A.FormatCastMessage(
      context.sourceName,
      context.spellID,
      context.spellName,
      nil,
      selfAuraDefinition.duration
    )
  end

  if context.combatEvent == "SPELL_AURA_REMOVED" and selfAuraDefinition then
    if selfAuraDefinition.flags and selfAuraDefinition.flags.announceOnExpire == false then
      return nil
    end

    if ValSpams_Options.announceMode == "ending" then
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
  local playerName = UnitName("player")
  local allowExternalCrowdControl = A.ShouldHandleTrackedCrowdControl(context)

  if not allowExternalCrowdControl
  and not A.IsPlayerSource(context, playerGUID, playerName)
  and context.destGUID ~= playerGUID
  then
    return
  end

  local eventMessage = A.HandleSourceCombatEvent(context, playerGUID, allowExternalCrowdControl)
  if eventMessage == nil then
    eventMessage = A.HandleDestCombatEvent(context, playerGUID)
  end

  if eventMessage == nil or eventMessage == "" then
    return
  end

  A.BroadcastMessage(eventMessage)
end

function A.OnEvent(_, event, ...)
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
