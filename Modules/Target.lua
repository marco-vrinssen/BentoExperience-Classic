-- CREATE TARGET BACKDROPS

TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 240)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetFrameBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48, 48)
TargetPortraitBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetPortraitBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
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
	TargetFrameTextureFrameName:SetFont(FONT, MEDIUM, "OUTLINE")
	
	TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
	TargetFrameTextureFrameLevelText:SetFont(FONT, MEDIUM, "OUTLINE")
    TargetFrameTextureFrameLevelText:SetTextColor(unpack(WHITE))

	TargetFrameTextureFrameHighLevelTexture:Hide()

	if UnitExists("target") then
		if UnitIsPlayer("target") then
			if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for enemy players that can be attacked
			else
				TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral or friendly players
			end
		else
			if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for hostile NPCs
			elseif UnitReaction("player", "target") == 4 and UnitCanAttack("player", "target") then
				TargetFrameTextureFrameName:SetTextColor(unpack(YELLOW)) -- Yellow for neutral but attackable NPCs
			else
				TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral non-attackable or friendly NPCs
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
	TargetFrameHealthBar:SetStatusBarTexture(BAR)
	TargetFrameHealthBar:SetStatusBarColor(unpack(GREEN))

	TargetFrameManaBar:ClearAllPoints()
	TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
	TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 3)
	TargetFrameManaBar:SetStatusBarTexture(BAR)
	
	local powerType = UnitPowerType("target")
    
    if powerType == 0 then -- Mana
        TargetFrameManaBar:SetStatusBarColor(unpack(BLUE))
    elseif powerType == 1 then -- Rage
        TargetFrameManaBar:SetStatusBarColor(unpack(RED))
    elseif powerType == 3 then -- Energy
        TargetFrameManaBar:SetStatusBarColor(unpack(YELLOW))
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


-- GENERATE AND UPDATE TARGET CLASSIFICATION TEXT

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


-- UPDATE TARGET RAID ICON

local RaidTargetBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
RaidTargetBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
RaidTargetBackdrop:SetSize(28, 28)
RaidTargetBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = EDGE, edgeSize = MEDIUM,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
RaidTargetBackdrop:SetBackdropColor(0, 0, 0, 1)
RaidTargetBackdrop:SetBackdropBorderColor(unpack(GREY))
RaidTargetBackdrop:Hide()

local function UpdateRaidTargetIcon()
    if GetRaidTargetIndex("target") then
        RaidTargetBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", RaidTargetBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(12, 12)
		TargetFrameTextureFrameRaidTargetIcon:SetFrameLevel(RaidTargetBackdrop:GetFrameLevel() + 2)
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


-- UPDATE TARGET CASTBAR

local TargetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
TargetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
TargetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
TargetSpellBarBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
TargetSpellBarBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetSpellBarBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 2)

local function TargetSpellBarUpdate()
	TargetFrameSpellBar:ClearAllPoints()
	TargetFrameSpellBar:SetPoint("TOPLEFT", TargetSpellBarBackdrop, "TOPLEFT", 3, -2)
	TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", TargetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
	TargetFrameSpellBar:SetStatusBarTexture(BAR)
	TargetFrameSpellBar:SetStatusBarColor(unpack(YELLOW))
	TargetFrameSpellBar.Border:SetTexture(nil)
	TargetFrameSpellBar.Flash:SetTexture(nil)
	TargetFrameSpellBar.Spark:SetTexture(nil)
	TargetFrameSpellBar.Icon:SetSize(TargetSpellBarBackdrop:GetHeight() - 4, TargetSpellBarBackdrop:GetHeight() - 4)
	TargetFrameSpellBar.Text:ClearAllPoints()
	TargetFrameSpellBar.Text:SetPoint("CENTER", TargetSpellBarBackdrop, "CENTER", 0, 0)
	TargetFrameSpellBar.Text:SetFont(FONT, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", TargetSpellBarUpdate)
TargetFrameSpellBar:HookScript("OnUpdate", TargetSpellBarUpdate)

local TargetSpellBarFrame = CreateFrame("Frame")
TargetSpellBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetSpellBarFrame:SetScript("OnEvent", TargetSpellBarUpdate)


-- UPDATE TARGET CONFIGURATION

local function TargetConfigUpdate()
	SetCVar("showTargetCastbar", 1)
	TARGET_FRAME_BUFFS_ON_TOP = true
end

local TargetConfigFrame = CreateFrame("Frame")
TargetConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetConfigFrame:SetScript("OnEvent", TargetConfigUpdate)