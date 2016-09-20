local enabled = true
local events = {}
local frame = CreateFrame("frame", "SnoopFrame")

local function IsHerb(msg)
	local openBracket = msg:find("%[")
	local closeBracket = msg:find("]")
	if not openBracket or not closeBracket then
		return false
	end
	lootedItemName = msg:sub(openBracket + 1, closeBracket - 1)
	-- print("Looted item name: " .. lootedItemName)
	for i, v in ipairs(herbs) do
		if lootedItemName == v then
			return true
		end
	end
	return false
end


local function PlayDankMeme()
	ret = PlaySoundFile("Interface\\AddOns\\Snoop\\smoke_weed.ogg")
	if not ret then
		print("[Snoop] Failed to play sound clip")
	end
end

-- function events:CHAT_MSG_SKILL(...)
-- 	local msg = select(1, ...)
-- 	if not msg or not msg:find("Herbalism") then
-- 		return
-- 	end
-- 	PlayDankMeme()
-- end


function events:CHAT_MSG_LOOT(...)
	local msg, chatLineId = select(1, ...)
	if msg then
		-- print("loot message: " .. msg)
		if IsHerb(msg) then
			PlayDankMeme()
		-- else
		-- 	print("didn't loot a herb!")
		end
	end
end


local function Snoop_OnEvent(self, event, ...)
	events[event](self, ...)
end


local function Snoop_RegisterEvents()
	for k, v in pairs(events) do
		frame:RegisterEvent(k);
	end
end


local function Snoop_UnRegisterEvents()
	for k, v in pairs(events) do
		frame:UnregisterEvent(k);
	end
end


function OnSnoopCmd(cmd)
	if cmd == "disable" and enabled then
		print("Setting Snoop to disabled")
		enabled = false
		Snoop_UnRegisterEvents()
	elseif cmd == "enable" and not enabled then
		print("Setting Snoop to enabled")
		enabled = true
		Snoop_RegisterEvents()
	else
		print("[Snoop] usage: /snoop <enable|disable>")
	end
end

Snoop_RegisterEvents()
frame:SetScript("OnEvent", Snoop_OnEvent);

SLASH_SNOOP_CMD1 = "/sn"
SLASH_SNOOP_CMD2 = "/snoop"
SlashCmdList["SNOOP_CMD"] = OnSnoopCmd