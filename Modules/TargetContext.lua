-- UPDATE TARGET RAID ICON

local RaidTargetBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
RaidTargetBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
RaidTargetBackdrop:SetSize(28, 28)
RaidTargetBackdrop:SetBackdrop({
    bgFile = T.BG,
    edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
RaidTargetBackdrop:SetBackdropColor(0, 0, 0, 1)
RaidTargetBackdrop:SetBackdropBorderColor(unpack(N.RGB))
RaidTargetBackdrop:Hide()

local function UpdateRaidTargetIcon()
    if GetRaidTargetIndex("target") then
        RaidTargetBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", RaidTargetBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(12, 12)
		TargetFrameTextureFrameRaidTargetIcon:SetFrameLevel(RaidTargetBackdrop:GetFrameLevel() + 1)
    else
        RaidTargetBackdrop:Hide()
    end
end

local RaidTargetFrame = CreateFrame("Frame")
RaidTargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
RaidTargetFrame:RegisterEvent("RAID_TARGET_UPDATE")
RaidTargetFrame:SetScript("OnEvent", UpdateRaidTargetIcon)


-- UPDATE TARGET GROUP INDICATORS

local function TargetGroupUpdate()
	TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
	TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local TargetGroupFrame = CreateFrame("Frame")
TargetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetGroupFrame:SetScript("OnEvent", TargetGroupUpdate)

hooksecurefunc("TargetFrame_Update", TargetGroupUpdate)