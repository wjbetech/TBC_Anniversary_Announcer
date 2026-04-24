local A = Announcer

function A.RenderTemplate(template, tokens)
  local renderedText = template

  for token, value in pairs(tokens) do
    renderedText = string.gsub(renderedText, token, tostring(value or """))
  end

  return renderedText
end

function A.GetDurationText(duration)
  if duration == nil or duration <= 0 then
    return ""
  end

  return tostring(duration).."s"
end

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
  local template = A.L.castMessage
	local actorName = A.GetDisplayActorName(sourceName)
	local spellText = A.GetSpellText(spellID, spellName)
	local displayTarget = A.GetDisplayTarget(destName)
	local durationSuffix = A.GetDurationSuffix(duration)

	if displayTarget then
		if actorName then
			template = A.L.castOnMessage
    else
      template = A.L.castOnMessageNoSource
    end
  else
    if actorName then
      template = A.L.castMessage
    else
      template = A.L.castMessageNoSource
    end
  end

	return A.RenderTemplate(template,
    {
      ["spell:source"] = actorName,
      ["spell:link"] = spellText,
      ["spell:target"] = displayTarget,
      ["spell:duration"] = durationSuffix
    })
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