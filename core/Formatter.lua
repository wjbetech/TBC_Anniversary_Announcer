---@diagnostic disable: undefined-global
local A = _G.ValSpams

function A.RenderTemplate(template, tokens)
  local renderedText = template

  for token, value in pairs(tokens) do
    renderedText = string.gsub(renderedText, token, tostring(value or ""))
  end

  renderedText = string.gsub(renderedText, "%s+", " ")
  renderedText = string.gsub(renderedText, "%s+([!%.,:%?])", "%1")
  renderedText = string.gsub(renderedText, "^%s+", "")
  renderedText = string.gsub(renderedText, "%s+$", "")

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
	return A.GetActorName(sourceName)
end

function A.GetDisplayTarget(destName)
	if destName and destName ~= "" then
		return destName
	end

	return nil
end

function A.GetMissTypeText(missType)
  local missTypeLabels = {
    MISS = A.L.outcomeMiss,
    DODGE = A.L.outcomeDodge,
    PARRY = A.L.outcomeParry,
    RESIST = A.L.outcomeResist,
    IMMUNE = A.L.outcomeImmune,
  }

  return missTypeLabels[missType] or tostring(missType or "")
end

function A.GetTemplateTokens(sourceName, spellID, spellName, destName, duration, missType, extraSpellID, extraSpellName, displayTargetOverride)
	return {
		["spell:source"] = A.GetDisplayActorName(sourceName),
		["spell:link"] = A.GetSpellText(spellID, spellName),
		["spell:target"] = displayTargetOverride or A.GetDisplayTarget(destName),
		["spell:duration"] = A.GetDurationText(duration),
		["spell:missType"] = A.GetMissTypeText(missType),
		["spell:extraLink"] = extraSpellID and A.GetSpellText(extraSpellID, extraSpellName) or tostring(extraSpellName or "")
	}
end

function A.FormatCastMessage(sourceName, spellID, spellName, destName, duration, isWhisper, isCrowdControl, displayTargetOverride)
	local displayTarget = displayTargetOverride or A.GetDisplayTarget(destName)
	local template = A.L.castMessage

	if displayTarget then
		if isWhisper then
			template = A.L.castWhisperOnMessage
		elseif isCrowdControl then
			template = A.L.castCrowdControlOnMessage
		elseif duration and duration > 0 then
			template = A.L.castOnMessage
		else
			template = A.L.castNoDurationOnMessage
		end
	end

	return A.RenderTemplate(
		template,
		A.GetTemplateTokens(sourceName, spellID, spellName, destName, duration, nil, nil, nil, displayTargetOverride)
	)
end

function A.FormatWhisperCastMessage(sourceName, spellID, spellName, destName, duration)
	return A.FormatCastMessage(sourceName, spellID, spellName, destName, duration, true, false)
end

function A.FormatEndedMessage(sourceName, spellID, spellName, destName)
	local displayTarget = A.GetDisplayTarget(destName)
	local template = displayTarget and A.L.endedOnMessage or A.L.endedMessage

	return A.RenderTemplate(template, A.GetTemplateTokens(sourceName, spellID, spellName, destName))
end

function A.FormatMissMessage(sourceName, spellID, spellName, destName, missType)
	return A.RenderTemplate(
		A.L.missMessage,
		A.GetTemplateTokens(sourceName, spellID, spellName, destName, nil, missType)
	)
end

function A.FormatTankMissMessage(sourceName, spellID, spellName, destName, missType)
	return A.RenderTemplate(
		A.L.tankMissMessage,
		A.GetTemplateTokens(sourceName, spellID, spellName, destName, nil, missType)
	)
end

function A.FormatInterruptMessage(sourceName, destName, interruptedSpellID, interruptedSpellName)
	local displayTarget = A.GetDisplayTarget(destName)
	local template = displayTarget and A.L.interruptOnMessage or A.L.interruptMessage

	return A.RenderTemplate(
		template,
		A.GetTemplateTokens(sourceName, interruptedSpellID, interruptedSpellName, destName)
	)
end

function A.FormatBreakMessage(sourceName, spellID, spellName, destName)
	local displayTarget = A.GetDisplayTarget(destName)
	local template = displayTarget and A.L.breakOnMessage or A.L.breakMessage

	return A.RenderTemplate(template, A.GetTemplateTokens(sourceName, spellID, spellName, destName))
end

function A.FormatDispelMessage(sourceName, spellID, spellName, destName, extraSpellID, extraSpellName)
	local displayTarget = A.GetDisplayTarget(destName)
	local template = displayTarget and A.L.dispelOnMessage or A.L.dispelMessage

	return A.RenderTemplate(
		template,
		A.GetTemplateTokens(sourceName, spellID, spellName, destName, nil, nil, extraSpellID, extraSpellName)
	)
end