-- CREATE TARGET BACKDROPS

TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 240)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
TargetFrameBackdrop:SetBackdropBorderColor(unpack(N.RGB))
TargetFrameBackdrop:SetFrameStrata("HIGH")
TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48, 48)
TargetPortraitBackdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
TargetPortraitBackdrop:SetBackdropBorderColor(unpack(N.RGB))
TargetPortraitBackdrop:SetFrameStrata("HIGH")
TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE TARGET FRAME

local function UpdateTargetFrame()
	TargetFrame:ClearAllPoints()
	TargetFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, 0)
	TargetFrame:SetPoint("TOPRIGHT", TargetPortraitBackdrop, "TOPRIGHT", 0, 0)
	TargetFrame:SetAttribute("unit", "target")
	TargetFrame:RegisterForClicks("AnyUp")
	TargetFrame:SetAttribute("type1", "target")
	TargetFrame:SetAttribute("type2", "togglemenu")

	TargetFrameBackground:ClearAllPoints()
	TargetFrameBackground:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 3, -3)
	TargetFrameBackground:SetPoint("BOTTOMRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", -3, 3)

	TargetFrameTextureFrameTexture:Hide()
	TargetFrameTextureFramePVPIcon:SetAlpha(0)

	TargetFrameTextureFrameDeadText:Hide()

	TargetFrameNameBackground:Hide()
	TargetFrameTextureFrameName:ClearAllPoints()
	TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -7)
	TargetFrameTextureFrameName:SetFont(F.TYPE, F.SIZE, "OUTLINE")
	
	TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
	TargetFrameTextureFrameLevelText:SetFont(F.TYPE, F.SIZE, "OUTLINE")
    TargetFrameTextureFrameLevelText:SetTextColor(unpack(W.RGB))

	TargetFrameTextureFrameHighLevelTexture:Hide()

	if UnitExists("target") then
		if UnitIsPlayer("target") then
			if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(R.RGB)) -- Red for enemy players that can be attacked
			else
				TargetFrameTextureFrameName:SetTextColor(unpack(W.RGB)) -- White for neutral or friendly players
			end
		else
			if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(R.RGB)) -- Red for hostile NPCs
			elseif UnitReaction("player", "target") == 4 and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(Y.RGB)) -- Yellow for neutral but attackable NPCs
			else
				TargetFrameTextureFrameName:SetTextColor(unpack(W.RGB)) -- White for neutral non-attackable or friendly NPCs
			end
		end
	end
end

local TargetFrameFrame = CreateFrame("Frame")
TargetFrameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameFrame:SetScript("OnEvent", UpdateTargetFrame)


-- UPDATE TARGET RESOURCES

local function UpdateTargetResources()
	TargetFrameHealthBar:ClearAllPoints()
	TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 16)
	TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)
	TargetFrameHealthBar:SetStatusBarTexture(T.BAR)
	TargetFrameHealthBar:SetStatusBarColor(unpack(G.RGB))

	TargetFrameManaBar:ClearAllPoints()
	TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
	TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 3)
	TargetFrameManaBar:SetStatusBarTexture(T.BAR)
	
	local powerType = UnitPowerType("target")
    
    if powerType == 0 then -- Mana
        TargetFrameManaBar:SetStatusBarColor(unpack(B.RGB))
    elseif powerType == 1 then -- Rage
        TargetFrameManaBar:SetStatusBarColor(unpack(R.RGB))
    elseif powerType == 3 then -- Energy
        TargetFrameManaBar:SetStatusBarColor(unpack(Y.RGB))
    end
end

local TargetResourceFrame = CreateFrame("Frame")
TargetResourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetResourceFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetResourceFrame:RegisterEvent("UNIT_HEALTH")
TargetResourceFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
TargetResourceFrame:RegisterEvent("UNIT_MAXHEALTH")
TargetResourceFrame:RegisterEvent("UNIT_POWER_UPDATE")
TargetResourceFrame:RegisterEvent("UNIT_MAXPOWER")
TargetResourceFrame:RegisterEvent("UNIT_DISPLAYPOWER")
TargetResourceFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" then
        UpdateTargetResources()
    elseif unit == "target" then
        UpdateTargetResources()
    end
end)


-- UPDATE TARGET PORTRAIT

local function TargetPortraitUpdate()
	TargetFramePortrait:ClearAllPoints()
	TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
	TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local TargetPortraitFrame = CreateFrame("Frame")
TargetPortraitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetPortraitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetPortraitFrame:SetScript("OnEvent", TargetPortraitUpdate)

hooksecurefunc("TargetFrame_Update", TargetPortraitUpdate)
hooksecurefunc("UnitFramePortrait_Update", TargetPortraitUpdate)

local function PortraitTextureUpdate(TargetPortrait)
	if TargetPortrait.unit == "target" and TargetPortrait.portrait then
		if UnitIsPlayer(TargetPortrait.unit) then
			local PortraitTexture = CLASS_ICON_TCOORDS[select(2, UnitClass(TargetPortrait.unit))]
			if PortraitTexture then
				TargetPortrait.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
				local Left, Right, Top, Bottom = unpack(PortraitTexture)
				local LeftUpdate  = Left + (Right - Left) * 0.15
				local RightUpdate = Right - (Right - Left) * 0.15
				local TopUpdate   = Top + (Bottom - Top) * 0.15
				local BottomUpdate = Bottom - (Bottom - Top) * 0.15
				TargetPortrait.portrait:SetTexCoord(LeftUpdate, RightUpdate, TopUpdate, BottomUpdate)
				TargetPortrait.portrait:SetDrawLayer("BACKGROUND", -1)
			end
		else
			TargetPortrait.portrait:SetTexCoord(0.2, 0.8, 0.2, 0.8)
		end
	end
end

hooksecurefunc("UnitFramePortrait_Update", PortraitTextureUpdate)