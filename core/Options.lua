local A = Announcer
local state = A.state

function A.RefreshOptionsPanel()
	for optionName, checkbox in pairs(state.optionCheckboxes) do
		checkbox:SetChecked(Announcer_Options[optionName])
	end

	for spellKey, checkbox in pairs(state.trackedSpellCheckboxes) do
		checkbox:SetChecked(Announcer_Options.trackedSpells[spellKey])
	end

	if state.announceModeDropdown then
		UIDropDownMenu_SetSelectedValue(state.announceModeDropdown, Announcer_Options.announceMode)
		UIDropDownMenu_SetText(state.announceModeDropdown, A.announceModeLabels[Announcer_Options.announceMode])
	end

	if state.channelModeDropdown then
		UIDropDownMenu_SetSelectedValue(state.channelModeDropdown, Announcer_Options.channelMode)
		UIDropDownMenu_SetText(state.channelModeDropdown, A.channelModeLabels[Announcer_Options.channelMode])
	end

	if state.optionsPanel and state.optionsPanel.statusText then
		state.optionsPanel.statusText:SetText(
			A.optionLabels.announce..": "..A.ColorText(Announcer_Options.announce).."    "..
			A.optionLabels.taunt..": "..A.ColorText(Announcer_Options.taunt).."    "..
			A.optionLabels.trackTrinkets..": "..A.ColorText(Announcer_Options.trackTrinkets).."    "..
			A.optionLabels.showPlayerName..": "..A.ColorText(Announcer_Options.showPlayerName).."    "..
			A.optionLabels.showTarget..": "..A.ColorText(Announcer_Options.showTarget).."    "..
			A.optionLabels.debug..": "..A.ColorText(Announcer_Options.debug).."    "..
			A.L.statusChannel..": "..A.channelModeLabels[Announcer_Options.channelMode].."    "..
			A.L.statusMode..": "..A.announceModeLabels[Announcer_Options.announceMode]
		)
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

function A.CreateCheckbox(parent, optionName, anchor)
	local checkbox = CreateFrame("CheckButton", "$parent"..optionName, parent, "InterfaceOptionsCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -12)
	checkbox.Text:SetText(A.optionLabels[optionName])
	checkbox.tooltipText = A.optionDescriptions[optionName]
	checkbox:SetScript("OnClick", function(self)
		A.SetOption(optionName, self:GetChecked())
	end)

	state.optionCheckboxes[optionName] = checkbox
	return checkbox
end

function A.CreateTrackedSpellCheckbox(parent, spellDefinition, anchor)
	local checkbox = CreateFrame("CheckButton", "$parent"..spellDefinition.key, parent, "InterfaceOptionsCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
	checkbox.Text:SetText(A.GetSpellText(spellDefinition.spellID, spellDefinition.spellName)..A.GetDurationSuffix(spellDefinition.duration))
	checkbox:SetScript("OnClick", function(self)
		A.SetTrackedSpellEnabled(spellDefinition.key, self:GetChecked())
	end)

	state.trackedSpellCheckboxes[spellDefinition.key] = checkbox
	return checkbox
end

function A.InitializeAnnounceModeDropdown(self)
	for _, mode in ipairs(A.announceModeOrder) do
		local info = UIDropDownMenu_CreateInfo()
		info.text = A.announceModeLabels[mode]
		info.value = mode
		info.checked = (Announcer_Options.announceMode == mode)
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
		info.checked = (Announcer_Options.channelMode == mode)
		info.func = function(buttonSelf)
			UIDropDownMenu_SetSelectedValue(self, buttonSelf.value)
			UIDropDownMenu_SetText(self, A.channelModeLabels[buttonSelf.value])
			A.SetChannelMode(buttonSelf.value)
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

function A.CreateClassOptionsPanel(classToken, parentCategory)
	if state.classPanels[classToken] then
		return state.classPanels[classToken]
	end

	local className = LOCALIZED_CLASS_NAMES_MALE[classToken] or classToken
	local panel = CreateFrame("Frame", "Announcer"..classToken.."OptionsPanel", UIParent)
	panel.name = className

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(className)

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(420)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetText(A.L.classSpellsDescription)

	local anchor = subtitle
	local spellDefinitions = A.GetClassSpellDefinitions(classToken)
	if #spellDefinitions == 0 then
		local emptyText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		emptyText:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
		emptyText:SetText(A.L.noTrackedSpells)
	else
		for _, spellDefinition in ipairs(spellDefinitions) do
			anchor = A.CreateTrackedSpellCheckbox(panel, spellDefinition, anchor)
		end
	end

	A.RegisterOptionsPanel(panel, parentCategory, A.L.classes)
	state.classPanels[classToken] = panel
	return panel
end

function A.CreateClassOptionsPanels(parentCategory)
	if state.classesPanel then
		return
	end

	local panel = CreateFrame("Frame", "AnnouncerClassesOptionsPanel", UIParent)
	panel.name = A.L.classes

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(A.L.classes)

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(420)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetText(A.L.classesDescription)

	state.classesPanel = panel
	state.classesCategory = A.RegisterOptionsPanel(panel, parentCategory, A.name)

	for _, classToken in ipairs(A.classOrder) do
		A.CreateClassOptionsPanel(classToken, state.classesCategory)
	end
end

function A.CreateOptionsPanel()
	if state.optionsPanel then
		return
	end

	local panel = CreateFrame("Frame", "AnnouncerOptionsPanel", UIParent)
	panel.name = A.name

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(A.name)

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	subtitle:SetWidth(420)
	subtitle:SetJustifyH("LEFT")
	subtitle:SetText(A.L.optionsSubtitle)

	local anchor = subtitle
	for _, optionName in ipairs(A.optionOrder) do
		anchor = A.CreateCheckbox(panel, optionName, anchor)
	end

	local dropdownLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	dropdownLabel:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -20)
	dropdownLabel:SetText(A.L.channelMode)

	local dropdownDescription = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	dropdownDescription:SetPoint("TOPLEFT", dropdownLabel, "BOTTOMLEFT", 0, -6)
	dropdownDescription:SetWidth(420)
	dropdownDescription:SetJustifyH("LEFT")
	dropdownDescription:SetText(A.L.channelModeDescription)

	local channelDropdown = CreateFrame("Frame", "AnnouncerChannelModeDropdown", panel, "UIDropDownMenuTemplate")
	channelDropdown:SetPoint("TOPLEFT", dropdownDescription, "BOTTOMLEFT", -16, -8)
	UIDropDownMenu_SetWidth(channelDropdown, 220)
	UIDropDownMenu_Initialize(channelDropdown, A.InitializeChannelModeDropdown)
	state.channelModeDropdown = channelDropdown

	local announceModeLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	announceModeLabel:SetPoint("TOPLEFT", channelDropdown, "BOTTOMLEFT", 16, -10)
	announceModeLabel:SetText(A.L.announceMode)

	local announceModeDescription = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	announceModeDescription:SetPoint("TOPLEFT", announceModeLabel, "BOTTOMLEFT", 0, -6)
	announceModeDescription:SetWidth(420)
	announceModeDescription:SetJustifyH("LEFT")
	announceModeDescription:SetText(A.L.announceModeDescription)

	local dropdown = CreateFrame("Frame", "AnnouncerAnnounceModeDropdown", panel, "UIDropDownMenuTemplate")
	dropdown:SetPoint("TOPLEFT", announceModeDescription, "BOTTOMLEFT", -16, -8)
	UIDropDownMenu_SetWidth(dropdown, 220)
	UIDropDownMenu_Initialize(dropdown, A.InitializeAnnounceModeDropdown)
	state.announceModeDropdown = dropdown

	local statusText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	statusText:SetPoint("TOPLEFT", dropdown, "BOTTOMLEFT", 16, -10)
	statusText:SetJustifyH("LEFT")
	panel.statusText = statusText

	local helpText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	helpText:SetPoint("TOPLEFT", statusText, "BOTTOMLEFT", 0, -12)
	helpText:SetWidth(420)
	helpText:SetJustifyH("LEFT")
	helpText:SetText(A.L.helpText)

	state.optionsPanel = panel
	state.optionsCategory = A.RegisterOptionsPanel(panel)
	A.CreateClassOptionsPanels(state.optionsCategory)
	A.RefreshOptionsPanel()
end