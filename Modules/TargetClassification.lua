-- GENERATE TARGET CLASSIFICATION TEXT

local TargetClassificationText = TargetFrame:CreateFontString(nil, "OVERLAY")
TargetClassificationText:SetFont(F.TYPE, F.SIZE, "OUTLINE")
TargetClassificationText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function TargetClassificationUpdate()
	local TargetClassification = UnitClassification("target")
	if TargetClassification == "worldboss" then
		TargetClassificationText:SetText("Boss")
		TargetClassificationText:SetTextColor(unpack(R.RGB))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(R.RGB))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(R.RGB))
	elseif TargetClassification == "elite" then
		TargetClassificationText:SetText("Elite")
		TargetClassificationText:SetTextColor(unpack(Y.RGB))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(Y.RGB))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(Y.RGB))
	elseif TargetClassification == "rare" then
		TargetClassificationText:SetText("Rare")
		TargetClassificationText:SetTextColor(unpack(W.RGB))
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(W.RGB))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(W.RGB))
	else
		TargetClassificationText:SetText("")
		TargetFrameBackdrop:SetBackdropBorderColor(unpack(N.RGB))
		TargetPortraitBackdrop:SetBackdropBorderColor(unpack(N.RGB))
	end
end

local TargetClassificationFrame = CreateFrame("Frame")
TargetClassificationFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetClassificationFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetClassificationFrame:SetScript("OnEvent", TargetClassificationUpdate)