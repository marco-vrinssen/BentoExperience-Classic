-- GENERATE TARGET CLASSIFICATION TEXT

local TargetClassificationText = TargetFrame:CreateFontString(nil, "OVERLAY")
TargetClassificationText:SetFont(FONT, MEDIUM, "OUTLINE")
TargetClassificationText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function TargetClassificationUpdate()
	local TargetClassification = UnitClassification("target")
	if TargetClassification == "worldboss" then
		TargetClassificationText:SetText("Boss")
		TargetClassificationText:SetTextColor(unpack(RED))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(RED))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(RED))
	elseif TargetClassification == "elite" then
		TargetClassificationText:SetText("Elite")
		TargetClassificationText:SetTextColor(unpack(YELLOW))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(YELLOW))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(YELLOW))
	elseif TargetClassification == "rare" then
		TargetClassificationText:SetText("Rare")
		TargetClassificationText:SetTextColor(unpack(WHITE))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE))
	else
		TargetClassificationText:SetText("")
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
	end
end

local TargetClassificationFrame = CreateFrame("Frame")
TargetClassificationFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetClassificationFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetClassificationFrame:SetScript("OnEvent", TargetClassificationUpdate)