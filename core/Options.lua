---@diagnostic disable: undefined-global, undefined-field
local A = _G.ValSpams
local ValSpams_Options = _G.ValSpams_Options
local state = A.state
local getSpellTexture = _G.GetSpellTexture

local PANEL_CONTENT_WIDTH = 520
local TEXT_WIDTH = 440
local CHECKBOX_TEXT_WIDTH = 390
local SCROLL_STEP = 48
local SPELL_ROW_INDENT = 22

function A.RefreshOptionsPanel()
	for optionName, checkbox in pairs(state.optionCheckboxes) do
		checkbox:SetChecked(ValSpams_Options[optionName])
	end

	for category, checkbox in pairs(state.categoryCheckboxes) do
		checkbox:SetChecked(A.IsCategoryEnabled(category))
	end

	for spellKey, checkbox in pairs(state.trackedSpellCheckboxes) do
		checkbox:SetChecked(ValSpams_Options.trackedSpells[spellKey])
	end

	if state.announceModeDropdown then
		UIDropDownMenu_SetSelectedValue(state.announceModeDropdown, ValSpams_Options.announceMode)
		UIDropDownMenu_SetText(state.announceModeDropdown, A.announceModeLabels[ValSpams_Options.announceMode])
	end

	if state.channelModeDropdown then
		UIDropDownMenu_SetSelectedValue(state.channelModeDropdown, ValSpams_Options.channelMode)
		UIDropDownMenu_SetText(state.channelModeDropdown, A.channelModeLabels[ValSpams_Options.channelMode])
	end

	if state.ccScopeDropdown then
		UIDropDownMenu_SetSelectedValue(state.ccScopeDropdown, ValSpams_Options.ccScope)
		UIDropDownMenu_SetText(state.ccScopeDropdown, A.ccScopeLabels[ValSpams_Options.ccScope])
	end

end

function A.OpenOptionsPanel()
	if not state.optionsPanel then
		return
	end

	if Settings and state.optionsPanel.categoryID then
		Settings.OpenToCategory(state.optionsPanel.categoryID)
		return
	end

	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(state.optionsPanel)
		InterfaceOptionsFrame_OpenToCategory(state.optionsPanel)
	end
end

function A.CreateSectionHeader(parent, text, anchor, spacing)
	local header = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	header:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, spacing or -20)
	header:SetText(text)
	return header
end

function A.CreateSectionDescription(parent, text, anchor)
	local description = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	description:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)
	description:SetWidth(TEXT_WIDTH)
	description:SetJustifyH("LEFT")
	description:SetJustifyV("TOP")
	description:SetNonSpaceWrap(true)
	description:SetWordWrap(true)
	description:SetText(text)
	return description
end

function A.CreateScrollablePanel(frameName)
	local panel = CreateFrame("Frame", frameName, UIParent)
	local scrollFrame = CreateFrame("ScrollFrame", frameName.."ScrollFrame", panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 8, -8)
	scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 8)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local nextValue = self:GetVerticalScroll() - (delta * SCROLL_STEP)
		if nextValue < 0 then
			nextValue = 0
		end
		self:SetVerticalScroll(nextValue)
	end)

	local content = CreateFrame("Frame", frameName.."Content", scrollFrame)
	content:SetWidth(PANEL_CONTENT_WIDTH)
	content:SetHeight(2200)
	scrollFrame:SetScrollChild(content)

	panel.scrollFrame = scrollFrame
	panel.content = content
	return panel, content
end

function A.FinalizeScrollableContent(content, anchor)
	local spacer = CreateFrame("Frame", nil, content)
	spacer:SetSize(1, 1)
	spacer:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -24)
	content.bottomSpacer = spacer
end

function A.CreateAlignedBottomAnchor(parent, anchor, offsetY)
	local spacer = CreateFrame("Frame", nil, parent)
	spacer:SetSize(1, 1)
	spacer:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 16, offsetY or -4)
	return spacer
end

function A.CreateCheckbox(parent, optionName, anchor)
	local checkbox = CreateFrame("CheckButton", "$parent"..optionName, parent, "InterfaceOptionsCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -12)
	checkbox.Text:SetText(A.optionLabels[optionName])
	checkbox.Text:SetWidth(CHECKBOX_TEXT_WIDTH)
	checkbox.Text:SetJustifyH("LEFT")
	checkbox.Text:SetNonSpaceWrap(true)
	checkbox.Text:SetWordWrap(true)
	checkbox.tooltipText = A.optionDescriptions[optionName]
	checkbox:SetScript("OnClick", function(self)
		A.SetOption(optionName, self:GetChecked())
	end)

	state.optionCheckboxes[optionName] = checkbox
	return checkbox
end

function A.CreateCategoryCheckbox(parent, category, anchor)
	local checkbox = CreateFrame("CheckButton", "$parent"..category, parent, "InterfaceOptionsCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
	checkbox.Text:SetText(A.categoryLabels[category])
	checkbox.Text:SetWidth(CHECKBOX_TEXT_WIDTH)
	checkbox.Text:SetJustifyH("LEFT")
	checkbox.Text:SetNonSpaceWrap(true)
	checkbox.Text:SetWordWrap(true)
	checkbox.tooltipText = A.L.categoryTogglesDescription
	checkbox:SetScript("OnClick", function(self)
		A.SetCategoryEnabled(category, self:GetChecked())
	end)

	state.categoryCheckboxes[category] = checkbox
	return checkbox
end

function A.CreateTrackedSpellCheckbox(parent, spellDefinition, anchor)
	local rowAnchor = CreateFrame("Frame", nil, parent)
	rowAnchor:SetSize(1, 1)
	rowAnchor:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)

	local checkbox = CreateFrame(
		"CheckButton",
		"$parent"..spellDefinition.key,
		parent,
		"InterfaceOptionsCheckButtonTemplate"
	)
	checkbox:SetPoint("TOPLEFT", rowAnchor, "TOPLEFT", SPELL_ROW_INDENT, 0)

	local icon = parent:CreateTexture(nil, "ARTWORK")
	icon:SetSize(18, 18)
	icon:SetPoint("RIGHT", checkbox, "LEFT", -6, 0)
	icon:SetTexture(getSpellTexture(spellDefinition.spellID))

	checkbox.Text:ClearAllPoints()
	checkbox.Text:SetPoint("LEFT", checkbox, "RIGHT", 4, 1)
	checkbox.Text:SetWidth(CHECKBOX_TEXT_WIDTH)
	checkbox.Text:SetJustifyH("LEFT")
	checkbox.Text:SetNonSpaceWrap(true)
	checkbox.Text:SetWordWrap(true)

	local durationText = A.GetDurationText(spellDefinition.duration)
	local suffix = durationText ~= "" and " "..durationText or ""
	checkbox.Text:SetText(A.GetSpellText(spellDefinition.spellID, spellDefinition.spellName)..suffix)
	checkbox:SetScript("OnClick", function(self)
		A.SetTrackedSpellEnabled(spellDefinition.key, self:GetChecked())
	end)

	state.trackedSpellCheckboxes[spellDefinition.key] = checkbox
	return rowAnchor
end

function A.InitializeAnnounceModeDropdown(self)
	for _, mode in ipairs(A.announceModeOrder) do
		local info = UIDropDownMenu_CreateInfo()
		info.text = A.announceModeLabels[mode]
		info.value = mode
		info.checked = (ValSpams_Options.announceMode == mode)
		info.func = function(buttonSelf)
			UIDropDownMenu_SetSelectedValue(self, buttonSelf.value)
			UIDropDownMenu_SetText(self, A.announceModeLabels[buttonSelf.value])
			A.SetAnnounceMode(buttonSelf.value)
		end
		UIDropDownMenu_AddButton(info)
	end
end

function A.InitializeChannelModeDropdown(self)
	for _, mode in ipairs(A.channelModeOrder) do
		local info = UIDropDownMenu_CreateInfo()
		info.text = A.channelModeLabels[mode]
		info.value = mode
		info.checked = (ValSpams_Options.channelMode == mode)
		info.func = function(buttonSelf)
			UIDropDownMenu_SetSelectedValue(self, buttonSelf.value)
			UIDropDownMenu_SetText(self, A.channelModeLabels[buttonSelf.value])
			A.SetChannelMode(buttonSelf.value)
		end
		UIDropDownMenu_AddButton(info)
	end
end

function A.InitializeCCScopeDropdown(self)
	for _, scope in ipairs(A.ccScopeOrder) do
		local info = UIDropDownMenu_CreateInfo()
		info.text = A.ccScopeLabels[scope]
		info.value = scope
		info.checked = (ValSpams_Options.ccScope == scope)
		info.func = function(buttonSelf)
			UIDropDownMenu_SetSelectedValue(self, buttonSelf.value)
			UIDropDownMenu_SetText(self, A.ccScopeLabels[buttonSelf.value])
			A.SetCCScope(buttonSelf.value)
		end
		UIDropDownMenu_AddButton(info)
	end
end

function A.RegisterOptionsPanel(panel, parentCategory, parentName)
	if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
		local category
		if parentCategory and Settings.RegisterCanvasLayoutSubcategory then
			category = Settings.RegisterCanvasLayoutSubcategory(parentCategory, panel, panel.name, panel.name)
		else
			category = Settings.RegisterCanvasLayoutCategory(panel, panel.name, panel.name)
			Settings.RegisterAddOnCategory(category)
		end
		panel.categoryID = category:GetID()
		return category
	end

	if parentName then
		panel.parent = parentName
	end

	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(panel)
	end

	return panel
end

function A.GetSortedSpellDefinitions(classToken)
	local sortedDefinitions = {}
	for _, spellDefinition in ipairs(A.GetClassSpellDefinitions(classToken)) do
		table.insert(sortedDefinitions, spellDefinition)
	end

	table.sort(sortedDefinitions, function(left, right)
		local leftCategory = 999
		local rightCategory = 999
		for index, category in ipairs(A.categoryOrder) do
			if category == left.category then
				leftCategory = index
			end
			if category == right.category then
				rightCategory = index
			end
		end

		if leftCategory ~= rightCategory then
			return leftCategory < rightCategory
		end

		return left.spellName < right.spellName
	end)

	return sortedDefinitions
end

function A.CreateClassOptionsPanel(classToken, parentCategory)
	if state.classPanels[classToken] then
		return state.classPanels[classToken]
	end

	local className = LOCALIZED_CLASS_NAMES_MALE[classToken] or classToken
	local panel, content = A.CreateScrollablePanel("ValSpams"..classToken.."OptionsPanel")
	panel.name = className

	local title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(className)

	local subtitle = A.CreateSectionDescription(content, A.L.classSpellsDescription, title)
	local anchor = subtitle
	local spellDefinitions = A.GetSortedSpellDefinitions(classToken)

	if #spellDefinitions == 0 then
		local emptyText = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		emptyText:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
		emptyText:SetWidth(TEXT_WIDTH)
		emptyText:SetJustifyH("LEFT")
		emptyText:SetJustifyV("TOP")
		emptyText:SetNonSpaceWrap(true)
		emptyText:SetWordWrap(true)
		emptyText:SetText(A.L.noTrackedSpells)
		anchor = emptyText
	else
		local currentCategory = nil
		for _, spellDefinition in ipairs(spellDefinitions) do
			if spellDefinition.category ~= currentCategory then
				anchor = A.CreateSectionHeader(content, A.categoryLabels[spellDefinition.category], anchor, -16)
				currentCategory = spellDefinition.category
			end
			anchor = A.CreateTrackedSpellCheckbox(content, spellDefinition, anchor)
		end
	end

	A.FinalizeScrollableContent(content, anchor)

	A.RegisterOptionsPanel(panel, parentCategory, A.L.classes)
	state.classPanels[classToken] = panel
	return panel
end

function A.CreateClassOptionsPanels(parentCategory)
	if state.classesPanel then
		return
	end

	local panel, content = A.CreateScrollablePanel("ValSpamsClassesOptionsPanel")
	panel.name = A.L.classes

	local title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(A.L.classes)

	local subtitle = A.CreateSectionDescription(content, A.L.classesDescription, title)
	state.classesPanel = panel
	state.classesCategory = A.RegisterOptionsPanel(panel, parentCategory, A.name)

	for _, classToken in ipairs(A.classOrder) do
		A.CreateClassOptionsPanel(classToken, state.classesCategory)
	end

	A.FinalizeScrollableContent(content, subtitle)
	panel.anchor = subtitle
end

function A.CreateOptionsPanel()
	if state.optionsPanel then
		return
	end

	local panel, content = A.CreateScrollablePanel("ValSpamsOptionsPanel")
	panel.name = A.name

	local title = content:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(A.name)

	local subtitle = A.CreateSectionDescription(content, A.L.optionsSubtitle, title)

	local generalHeader = A.CreateSectionHeader(content, A.L.announce, subtitle, -18)
	local generalAnchor = A.CreateCheckbox(content, "announce", generalHeader)
	generalAnchor = A.CreateCheckbox(content, "trackTrinkets", generalAnchor)
	generalAnchor = A.CreateCheckbox(content, "debug", generalAnchor)

	local categoryHeader = A.CreateSectionHeader(content, A.L.categoryToggles, generalAnchor, -20)
	local categoryDescription = A.CreateSectionDescription(content, A.L.categoryTogglesDescription, categoryHeader)
	local categoryAnchor = categoryDescription
	for _, category in ipairs(A.categoryOrder) do
		categoryAnchor = A.CreateCategoryCheckbox(content, category, categoryAnchor)
	end

	local warningOffensive = A.CreateSectionDescription(content, A.L.warningOffensive, categoryAnchor)
	local warningCrowdControl = A.CreateSectionDescription(content, A.L.warningCrowdControl, warningOffensive)
	local warningTrinkets = A.CreateSectionDescription(content, A.L.warningTrinkets, warningCrowdControl)
	local warningAnchor = warningTrinkets
	if A.ShouldDisableInterruptCategory and A.ShouldDisableInterruptCategory() then
		warningAnchor = A.CreateSectionDescription(content, A.L.warningInterruptElvUI, warningTrinkets)
	end

	local channelHeader = A.CreateSectionHeader(content, A.L.channelMode, warningAnchor, -20)
	local channelDescription = A.CreateSectionDescription(content, A.L.channelModeDescription, channelHeader)
	local channelDropdown = CreateFrame("Frame", "ValSpamsChannelModeDropdown", content, "UIDropDownMenuTemplate")
	channelDropdown:SetPoint("TOPLEFT", channelDescription, "BOTTOMLEFT", -16, -8)
	UIDropDownMenu_SetWidth(channelDropdown, 220)
	UIDropDownMenu_Initialize(channelDropdown, A.InitializeChannelModeDropdown)
	state.channelModeDropdown = channelDropdown
	local channelAnchor = A.CreateAlignedBottomAnchor(content, channelDropdown)

	local announceModeHeader = A.CreateSectionHeader(content, A.L.announceMode, channelAnchor, -10)
	local announceModeDescription = A.CreateSectionDescription(content, A.L.announceModeDescription, announceModeHeader)
	local announceModeDropdown = CreateFrame("Frame", "ValSpamsAnnounceModeDropdown", content, "UIDropDownMenuTemplate")
	announceModeDropdown:SetPoint("TOPLEFT", announceModeDescription, "BOTTOMLEFT", -16, -8)
	UIDropDownMenu_SetWidth(announceModeDropdown, 220)
	UIDropDownMenu_Initialize(announceModeDropdown, A.InitializeAnnounceModeDropdown)
	state.announceModeDropdown = announceModeDropdown
	local announceModeAnchor = A.CreateAlignedBottomAnchor(content, announceModeDropdown)

	local ccScopeHeader = A.CreateSectionHeader(content, A.L.ccScope, announceModeAnchor, -10)
	local ccScopeDescription = A.CreateSectionDescription(content, A.L.ccScopeDescription, ccScopeHeader)
	local ccScopeDropdown = CreateFrame("Frame", "ValSpamsCCScopeDropdown", content, "UIDropDownMenuTemplate")
	ccScopeDropdown:SetPoint("TOPLEFT", ccScopeDescription, "BOTTOMLEFT", -16, -8)
	UIDropDownMenu_SetWidth(ccScopeDropdown, 220)
	UIDropDownMenu_Initialize(ccScopeDropdown, A.InitializeCCScopeDropdown)
	state.ccScopeDropdown = ccScopeDropdown

	A.FinalizeScrollableContent(content, ccScopeDropdown)

	state.optionsPanel = panel
	state.optionsCategory = A.RegisterOptionsPanel(panel)
	A.CreateClassOptionsPanels(state.optionsCategory)
	A.RefreshOptionsPanel()
end