--Initialize variables if they are not saved
if ENABLED == nil then
	ENABLED = 1
end

if VERBOSE == nil then
	VERBOSE = 0
end

--Default whitelist includes the withered army training zones from legion and island expeditions from BFA
if WHITELIST == nil then
	WHITELIST = {
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
end

version = "v3.0.0"

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
						print("BeQuiet blocked a talking head. /bq verbose to turn these messages off.")
					end
				end
			end
		end)
	self:UnregisterEvent(event)
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
local function MyAddonCommands(arg1, arg2, arg3)
	if arg1 == 'off' then
		ENABLED = 0
		print('BeQuiet disabled - now allowing talking heads.')
	elseif arg1 == 'on' then
		ENABLED = 1
		print('BeQuiet enabled - now blocking talking heads except for whitelisted zones.')
	elseif arg1 == 'whitelist' then
		if arg2 == nil then
			print ('Options:')
			print('add *Zone Name* - adds a zone (Orgrimmar) or sub-zone (Valley of Strength) name to the whitelist. Case sensitive!')
			print('remove *Zone Name* - removes a zone (Orgrimmar) or sub-zone (Valley of Strength) name from the whitelist. Case sensitive!')
			print('reset - resets the whitelist to the default zones. (Withered Army Training & Island Expeditions)')
			print('show - show the current zones on the whitelist.')
		elseif arg2 == 'add' then
			if arg3 ~= nil then
				table.insert(WHITELIST, arg3)
				print(arg3 .. ' added to the whitelist.')
			else
				print('Provide a zone name (Orgimmar) or sub-zone name (Valley of Strength) to add to the whitelist. Case sensitive!')
			end
		elseif arg2 == 'remove' then
			if arg3 ~= nil then
				if has_value(WHITELIST, arg3) then
					table.remove(WHITELIST, arg3)
					print(arg3 .. ' removed from the whitelist.')
				else
					print('Zone name was not found in the whitelist.')
				end
			else
				print('Provide a zone name or sub-zone name to be removed from the whitelist. Case sensitive!')
			end
		elseif arg2 == 'reset' then
			WHITELIST = {
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
			print('Whitelist has been reset to default.')
		elseif arg2 == 'show' then
			print(table.concat(WHITELIST, ', '))
		end
	elseif arg1 == 'verbose' then
		if VERBOSE == 0 then
			VERBOSE = 1
			print('Verbose mode enabled. A chat message will print when a talking head is blocked.')
		elseif VERBOSE == 1 then
			VERBOSE = 0
			print('Verbose mode disabled. A chat message will not print when a talking head is blocked.')
		end
	elseif arg1 == nil then
		print('BeQuiet version ' .. version)
		print('Options: on | off | whitelist | verbose')
	end
end

--Add /bq to slash command list and register its function
SLASH_BQ1 = '/bq'
SlashCmdList["BQ"] = MyAddonCommands

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)
