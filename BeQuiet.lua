--Create the frame
local f = CreateFrame("Frame")

--Main function
function f:OnEvent(event, addon)
	--Check if the talkinghead addon is being loaded
	if addon == "Blizzard_TalkingHeadUI" then
		hooksecurefunc("TalkingHeadFrame_PlayCurrent", function()
			--Query subzone text when the talkinghead plays
			zoneName = GetSubZoneText();
			--If we are not doing withered training, suppress the talkinghead
			if zoneName ~= "Temple of Fal'adora" and
			   zoneName ~= "Falanaar Tunnels" and
			   zoneName ~= "Shattered Locus" then
				TalkingHeadFrame_CloseImmediately()
			end
		end)
	self:UnregisterEvent(event)
	end
end

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", f.OnEvent)