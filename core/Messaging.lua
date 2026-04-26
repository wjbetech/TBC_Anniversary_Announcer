---@diagnostic disable: undefined-global
local A = _G.ValSpams
local ValSpams_Options = _G.ValSpams_Options

local function SanitizePublicChatMessage(msg)
	local sanitizedMessage = tostring(msg or "")

	sanitizedMessage = sanitizedMessage:gsub("|c%x%x%x%x%x%x%x%x", "")
	sanitizedMessage = sanitizedMessage:gsub("|r", "")
	sanitizedMessage = sanitizedMessage:gsub("|H.-|h(.-)|h", "%1")
	sanitizedMessage = sanitizedMessage:gsub("|T.-|t", "")

	return sanitizedMessage
end

local function SendAnnouncementMessage(msg, chatType, target)
	local outgoingMessage = msg
	if chatType == "SAY" or chatType == "YELL" then
		outgoingMessage = SanitizePublicChatMessage(msg)
	end

	SendChatMessage(outgoingMessage, chatType, nil, target)
	return true
end

function A.ColorText(value)
	if value then
		return "|cff00FF00["..tostring(value).."]|r"
	end

	return "|cffFF0000["..tostring(value).."]|r"
end

function A.Message(msg)
	if msg == nil then
		msg = "nil"
	end

	DEFAULT_CHAT_FRAME:AddMessage("|cffACC3EB-[ValSpams]- |r"..msg)
end

function A.BroadcastMessage(msg)
	if msg == nil or msg == "" or not ValSpams_Options.announce then
		return
	end

	if ValSpams_Options.channelMode == "say_only" then
		SendAnnouncementMessage(msg, "SAY")
		return
	end

	if ValSpams_Options.channelMode == "yell_only" then
		SendAnnouncementMessage(msg, "YELL")
		return
	end

	if IsInRaid() then
		SendAnnouncementMessage(msg, "RAID")
	elseif IsInGroup() then
		SendAnnouncementMessage(msg, "PARTY")
	else
		SendAnnouncementMessage(msg, "YELL")
	end
end