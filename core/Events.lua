local A = Announcer
local trackedAuraTimers = A.state.trackedAuraTimers

function A.GetTrackedAuraKey(spellName, spellID, destGUID)
	return tostring(spellID or spellName)..":"..tostring(destGUID)
end

function A.ClearTrackedAuraTimers(spellName, spellID, destGUID)
	trackedAuraTimers[A.GetTrackedAuraKey(spellName, spellID, destGUID)] = nil
end

function A.ScheduleTrackedAuraCountdown(sourceName, spellName, spellID, destName, destGUID, duration)
	if not C_Timer or duration == nil or duration < 3 then
		return
	end

	local timerKey = A.GetTrackedAuraKey(spellName, spellID, destGUID)
	local timerToken = {}
	trackedAuraTimers[timerKey] = timerToken

	for secondsRemaining = 3, 1, -1 do
		local delay = duration - secondsRemaining
		if delay >= 0 then
			C_Timer.After(delay, function()
				if trackedAuraTimers[timerKey] ~= timerToken then
					return
				end

				if Announcer_Options.announceMode == "countdown" then
					A.BroadcastMessage(A.FormatCountdownMessage(sourceName, spellID, spellName, destName, secondsRemaining))
				end

				if secondsRemaining == 1 then
					trackedAuraTimers[timerKey] = nil
				end
			end)
		end
	end
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

	local playerGUID = UnitGUID("player")
	local eventMessage = ""

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, extraArg1, extraArg2, extraArg3, extraArg4 = CombatLogGetCurrentEventInfo()
		local spellID = extraArg1
		local spellName = extraArg2
		local actorName = A.GetActorName(sourceName)

		if sourceGUID == playerGUID then
			if combatEvent == "SPELL_MISSED" then
				local hitDefinition = A.GetHitDefinition(spellName)
				local trackedAuraDefinition = A.GetTrackedAuraDefinition(spellName)
				local missType = extraArg4
				if A.IsTrackedSpellEnabled(hitDefinition) or A.IsTrackedSpellEnabled(trackedAuraDefinition) then
					eventMessage = A.FormatMissMessage(actorName, spellID, spellName, destName, missType)
				end
			else
				local trackedAuraDefinition = A.GetTrackedAuraDefinition(spellName)
				if Announcer_Options.taunt and A.IsTrackedSpellEnabled(trackedAuraDefinition) then
					if combatEvent == "SPELL_AURA_REFRESH" then
						A.ClearTrackedAuraTimers(spellName, spellID, destGUID)
					end

					if combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REFRESH" then
						eventMessage = A.FormatCastMessage(actorName, spellID, spellName, destName, trackedAuraDefinition.duration)
						if Announcer_Options.announceMode == "countdown" then
							A.ScheduleTrackedAuraCountdown(actorName, spellName, spellID, destName, destGUID, trackedAuraDefinition.duration)
						end
					elseif combatEvent == "SPELL_AURA_REMOVED" then
						A.ClearTrackedAuraTimers(spellName, spellID, destGUID)
						if Announcer_Options.announceMode == "ending" then
							eventMessage = A.FormatEndedMessage(actorName, spellID, spellName, destName)
						end
					end
				end

				local trinketDefinition = A.GetTrackedTrinketDefinition(spellName)
				if Announcer_Options.trackTrinkets and trinketDefinition and combatEvent == "SPELL_CAST_SUCCESS" then
					eventMessage = A.FormatCastMessage(actorName, spellID or trinketDefinition.spellID, spellName, nil, nil)
				end
			end
		end

		if destGUID == playerGUID then
			local cooldownDefinition = A.GetCooldownDefinition(spellName)
			if A.IsTrackedSpellEnabled(cooldownDefinition) then
				if combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REFRESH" then
					A.ClearTrackedAuraTimers(spellName, spellID, destGUID)
					eventMessage = A.FormatCastMessage(actorName, spellID, spellName, nil, cooldownDefinition.duration)
					if Announcer_Options.announceMode == "countdown" then
						A.ScheduleTrackedAuraCountdown(actorName, spellName, spellID, nil, destGUID, cooldownDefinition.duration)
					end
				elseif combatEvent == "SPELL_AURA_REMOVED" then
					A.ClearTrackedAuraTimers(spellName, spellID, destGUID)
					if Announcer_Options.announceMode == "ending" then
						eventMessage = A.FormatEndedMessage(actorName, spellID, spellName, nil)
					end
				end
			end

			local trinketDefinition = A.GetTrackedTrinketDefinition(spellName)
			if Announcer_Options.trackTrinkets and trinketDefinition and combatEvent == "SPELL_AURA_REMOVED" and Announcer_Options.announceMode == "ending" then
				eventMessage = A.FormatEndedMessage(actorName, spellID or trinketDefinition.spellID, spellName, nil)
			end
		end
	end

	A.BroadcastMessage(eventMessage)
end