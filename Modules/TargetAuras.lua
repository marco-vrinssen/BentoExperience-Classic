-- UPDATE TARGET AURAS

local function TargetAurasUpdate()
	local InitialBuff = _G["TargetFrameBuff1"]
	if InitialBuff then
		InitialBuff:ClearAllPoints()
		InitialBuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 2, 2)
	end
	local InitialDebuff = _G["TargetFrameDebuff1"]
	if InitialDebuff then
		InitialDebuff:ClearAllPoints()
		if InitialBuff then
			InitialDebuff:SetPoint("BOTTOMLEFT", InitialBuff, "TOPLEFT", 0, 2)
		else
			InitialDebuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 2, 2)
		end
	end
end

hooksecurefunc("TargetFrame_Update", TargetAurasUpdate)
hooksecurefunc("TargetFrame_UpdateAuras", TargetAurasUpdate)

local TargetAurasFrame = CreateFrame("Frame")
TargetAurasFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetAurasFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetAurasFrame:SetScript("OnEvent", TargetAurasUpdate)