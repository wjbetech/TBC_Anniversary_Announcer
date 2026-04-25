---@diagnostic disable: undefined-global
local A = ValSpams

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

	if ValSpams_Options.channelMode == "yell_only" then
		SendChatMessage(msg, "YELL")
		return
	end

	if IsInRaid() then
		SendChatMessage(msg, "RAID")
	elseif IsInGroup() then
		SendChatMessage(msg, "PARTY")
	else
		SendChatMessage(msg, "YELL")
	end
end