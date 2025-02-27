-- CREATE PLAYER FRAME BACKDROPS

PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", -190, 240)
PlayerFrameBackdrop:SetSize(124, 48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
PlayerFrameBackdrop:SetBackdropBorderColor(unpack(N.RGB))
PlayerFrameBackdrop:SetFrameStrata("HIGH")
PlayerFrameBackdrop:SetAttribute("unit", "player")
PlayerFrameBackdrop:RegisterForClicks("AnyUp")
PlayerFrameBackdrop:SetAttribute("type1", "target")
PlayerFrameBackdrop:SetAttribute("type2", "togglemenu")

PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48, 48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
PlayerPortraitBackdrop:SetBackdropBorderColor(unpack(N.RGB))
PlayerPortraitBackdrop:SetFrameStrata("HIGH")
PlayerPortraitBackdrop:SetAttribute("unit", "player")
PlayerPortraitBackdrop:RegisterForClicks("AnyUp")
PlayerPortraitBackdrop:SetAttribute("type1", "target")
PlayerPortraitBackdrop:SetAttribute("type2", "togglemenu")

-- UPDATE PLAYER FRAME

local function UpdatePlayerFrame()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("TOPLEFT", PlayerPortraitBackdrop, "TOPLEFT", 0, 0)
    PlayerFrame:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", 0, 0)

    PlayerFrameBackground:ClearAllPoints()
    PlayerFrameBackground:SetPoint("TOPLEFT", PlayerFrameBackdrop, "TOPLEFT", 3, -3)
    PlayerFrameBackground:SetPoint("BOTTOMRIGHT", PlayerFrameBackdrop, "BOTTOMRIGHT", -3, 3)

    PlayerFrameTexture:SetTexture(nil)
    PlayerStatusGlow:SetAlpha(0)
    PlayerStatusTexture:Hide()
    PlayerStatusTexture:SetTexture(nil)

    PlayerAttackBackground:SetTexture(nil)
    PlayerAttackGlow:SetTexture(nil)
    PlayerAttackIcon:SetTexture(nil)
    PlayerStatusGlow:Hide()
    PlayerRestGlow:SetTexture(nil)
    PlayerRestIcon:SetTexture(nil)
    PlayerPVPIconHitArea:Hide()
    PlayerPVPTimerText:Hide()
    PlayerPVPIcon:SetAlpha(0)

    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOP", PlayerFrameBackdrop, "TOP", 0, -5)
    PlayerName:SetFont(F.TYPE, F.SIZE, "OUTLINE")
    PlayerName:SetTextColor(unpack(W.RGB))

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
    PlayerLevelText:SetFont(F.TYPE, F.SIZE, "OUTLINE")
    PlayerLevelText:SetTextColor(unpack(W.RGB))

    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        PlayerLevelText:Hide()
    else
        PlayerLevelText:Show()
    end

    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(F.TYPE, F.SIZE, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(F.TYPE, F.SIZE, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(F.TYPE, F.SIZE, "OUTLINE")

    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(F.TYPE, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(F.TYPE, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(F.TYPE, 8, "OUTLINE")
end

local PlayerFrameFrame = CreateFrame("Frame")
PlayerFrameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameFrame:SetScript("OnEvent", UpdatePlayerFrame)








local function UpdatePlayerResources()

    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 16)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)
    PlayerFrameHealthBar:SetStatusBarTexture(T.BAR)
    PlayerFrameHealthBar:SetStatusBarColor(unpack(G.RGB))

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 4)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)
    PlayerFrameManaBar:SetStatusBarTexture(T.BAR)
    
    local powerType = UnitPowerType("player")
    
    if powerType == 0 then -- Mana
        PlayerFrameManaBar:SetStatusBarColor(unpack(B.RGB))
    elseif powerType == 1 then -- Rage
        PlayerFrameManaBar:SetStatusBarColor(unpack(R.RGB))
    elseif powerType == 3 then -- Energy
        PlayerFrameManaBar:SetStatusBarColor(unpack(Y.RGB))
    end
end

local PlayerResourceFrame = CreateFrame("Frame")
PlayerResourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerResourceFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
PlayerResourceFrame:RegisterEvent("UNIT_HEALTH")
PlayerResourceFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
PlayerResourceFrame:RegisterEvent("UNIT_MAXHEALTH")
PlayerResourceFrame:RegisterEvent("UNIT_POWER_UPDATE")
PlayerResourceFrame:RegisterEvent("UNIT_MAXPOWER")
PlayerResourceFrame:RegisterEvent("UNIT_DISPLAYPOWER")
PlayerResourceFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" then
        UpdatePlayerResources()
    elseif unit == "player" then
        UpdatePlayerResources()
    end
end)


-- UPDATE PLAYER PORTRAIT

local function UpdatePlayerPortrait()
    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint("CENTER", PlayerPortraitBackdrop, "CENTER", 0, 0)
    PlayerPortrait:SetTexCoord(0.2, 0.8, 0.2, 0.8)
    PlayerPortrait:SetSize(PlayerPortraitBackdrop:GetHeight() - 6, PlayerPortraitBackdrop:GetHeight() - 6)
    
    PlayerFrame:UnregisterEvent("UNIT_COMBAT")

    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint("BOTTOM", PlayerPortraitBackdrop, "TOP", 0, 0)

    PlayerMasterIcon:ClearAllPoints()
    PlayerMasterIcon:SetPoint("BOTTOM", PlayerLeaderIcon, "TOP", 0, 0)
    PlayerMasterIcon:SetScale(0.75)
end

local PlayerPortraitFrame = CreateFrame("Frame")
PlayerPortraitFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerPortraitFrame:SetScript("OnEvent", UpdatePlayerPortrait)