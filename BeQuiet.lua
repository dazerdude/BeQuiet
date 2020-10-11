version = "v3.0.0"
WL_DEFAULT = {
	"Temple of Fal'adora",
	"Falanaar Tunnels",
	"Shattered Locus",
	"Crestfall",
	"Snowblossom Village",
	"Havenswood",
	"Jorundall",
	"Molten Cay",
	"Un'gol Ruins",
	"The Rotting Mire",
	"Whispering Reef",
	"Verdant Wilds",
	"The Dread Chain",
	"Skittering Hollow"
}

--Initialize config variables if they are not saved
if ENABLED == nil then
	ENABLED = 1
end

if VERBOSE == nil then
	VERBOSE = 1
end

--Default whitelist includes the withered army training zones from legion and island expeditions from BFA
if WHITELIST == nil then
	WHITELIST = WL_DEFAULT
end

--Create the frame
local f = CreateFrame("Frame")

--Main function
function f:OnEvent(event, addon)
	--Check if the talkinghead addon is being loaded
	if addon == "Blizzard_TalkingHeadUI" then
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
			--Query current zone and subzone when talking head is triggered
			subZoneName = GetSubZoneText();
			zoneName = GetZoneText();
			--Only run this logic if the functionality is turned on
			if ENABLED == 1 then
				--Block the talking head unless its in the whitelist
				if not (has_value(WHITELIST, subZoneName) and has_value(WHITELIST, zoneName)) then
					--Close the talking head
					TalkingHeadFrame_CloseImmediately()
					if VERBOSE == 1 then
						print("BeQuiet blocked a talking head! /bq verbose to turn this alert off.")
					end
				end
			end
		end)
	self:UnregisterEvent(event)
	end
end

function removeFirst(tbl, val)
	for i, v in ipairs(tbl) do
		if v == val then
			return table.remove(tbl, i)
		end
	end
end

--Function to check if value in array
function has_value (tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

--Slash command function
function MyAddonCommands(args)
	if args == 'off' then
		ENABLED = 0
		print('BeQuiet disabled - now allowing talking heads.')
	end

	if args == 'on' then
		ENABLED = 1
		print('BeQuiet enabled - now blocking talking heads except for whitelisted zones.')
	end

	if args == 'whitelist currentzone' then
		zone = GetZoneText()
		if has_value(WHITELIST, zone) then
			removeFirst(WHITELIST, zone)
			print(zone .. ' removed from the whitelist.')
		else
			table.insert(WHITELIST, zone)
			print(zone .. ' added to the whitelist.')
		end
	end

	if args == 'whitelist currentsubzone' then
		zone = GetSubZoneText()
		if has_value(WHITELIST, zone) then
			removeFirst(WHITELIST, zone)
			print(zone .. ' removed from the whitelist.')
		else
			table.insert(WHITELIST, zone)
			print(zone .. ' added to the whitelist.')
		end
	end

	if args == 'reset' then
		WHITELIST = WL_DEFAULT
		print('Whitelist has been reset to default.')
	end

	if args == 'show' then
		print(table.concat(WHITELIST, ', '))
	end

	if args == 'verbose' then
		if VERBOSE == 0 then
			VERBOSE = 1
			print('Verbose mode enabled. A chat message will print when a talking head is blocked.')
		elseif VERBOSE == 1 then
			VERBOSE = 0
			print('Verbose mode disabled.')
		end
	end

	if args == 'whitelist' then
		print('whitelist (currentzone | currentsubzone) - toggle whitelisting for the current major zone (Orgrimmar) or sub-zone (Valley of Strength).')
	end

	if args == '' then
		print('BeQuiet version ' .. version)
		print('Options: on | off | verbose | whitelist | reset | show')
		print('-----')
		if ENABLED == 1 then
			print('BeQuiet is currently enabled.')
		elseif ENABLED == 0 then
			print('BeQuiet is currently disabled.')
		end
		if VERBOSE == 1 then
			print('Verbose mode is currently enabled.')
		elseif VERBOSE == 0 then
			print('Verbose mode is currently disabled.')
		end
	end
end

--Add /bq to slash command list and register its function
SLASH_BQ1 = '/bq'
SlashCmdList["BQ"] = MyAddonCommands

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)
