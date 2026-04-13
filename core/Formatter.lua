local A = Announcer

function A.GetSpellText(spellID, spellName)
	return GetSpellLink(spellID) or tostring(spellName)
end

function A.GetActorName(sourceName)
	if sourceName and sourceName ~= "" then
		return sourceName
	end

	return UnitName("player") or A.name
end

function A.GetDisplayActorName(sourceName)
	if not Announcer_Options.showPlayerName then
		return nil
	end

	return A.GetActorName(sourceName)
end

function A.GetDisplayTarget(destName)
	if not Announcer_Options.showTarget then
		return nil
	end

	if destName and destName ~= "" then
		return destName
	end

	return nil
end

function A.GetDurationSuffix(duration)
	if duration == nil or duration <= 0 then
		return ""
	end

	return " - "..tostring(duration).."s"
end

function A.FormatCastMessage(sourceName, spellID, spellName, destName, duration)
	local actorName = A.GetDisplayActorName(sourceName)
	local spellText = A.GetSpellText(spellID, spellName)
	local displayTarget = A.GetDisplayTarget(destName)
	local durationSuffix = A.GetDurationSuffix(duration)
	if displayTarget then
		if actorName then
			return string.format(A.L.castOnMessage, actorName, spellText, displayTarget, durationSuffix)
		end

		return string.format(A.L.castOnMessageNoSource, spellText, displayTarget, durationSuffix)
	end

	if actorName then
		return string.format(A.L.castMessage, actorName, spellText, durationSuffix)
	end

	return string.format(A.L.castMessageNoSource, spellText, durationSuffix)
end

function A.FormatCountdownMessage(sourceName, spellID, spellName, destName, secondsRemaining)
	local actorName = A.GetDisplayActorName(sourceName)
	local spellText = A.GetSpellText(spellID, spellName)
	local displayTarget = A.GetDisplayTarget(destName)
	if displayTarget then
		if actorName then
			return string.format(A.L.countdownMessage, actorName, spellText, displayTarget, secondsRemaining)
		end

		return string.format(A.L.countdownMessageNoSource, spellText, displayTarget, secondsRemaining)
	end

	if actorName then
		return string.format(A.L.countdownNoTargetMessage, actorName, spellText, secondsRemaining)
	end

	return string.format(A.L.countdownNoTargetMessageNoSource, spellText, secondsRemaining)
end

function A.FormatEndedMessage(sourceName, spellID, spellName, destName)
	local actorName = A.GetDisplayActorName(sourceName)
	local spellText = A.GetSpellText(spellID, spellName)
	local displayTarget = A.GetDisplayTarget(destName)
	if displayTarget then
		if actorName then
			return string.format(A.L.endedMessage, actorName, spellText, displayTarget)
		end

		return string.format(A.L.endedMessageNoSource, spellText, displayTarget)
	end

	if actorName then
		return string.format(A.L.endedNoTargetMessage, actorName, spellText)
	end

	return string.format(A.L.endedNoTargetMessageNoSource, spellText)
end

function A.FormatMissMessage(sourceName, spellID, spellName, destName, missType)
	local actorName = A.GetDisplayActorName(sourceName)
	local spellText = A.GetSpellText(spellID, spellName)
	local displayTarget = A.GetDisplayTarget(destName)
	if displayTarget then
		if actorName then
			return string.format(A.L.missMessage, actorName, spellText, displayTarget, tostring(missType))
		end

		return string.format(A.L.missMessageNoSource, spellText, displayTarget, tostring(missType))
	end

	if actorName then
		return string.format(A.L.missNoTargetMessage, actorName, spellText, tostring(missType))
	end

	return string.format(A.L.missNoTargetMessageNoSource, spellText, tostring(missType))
end