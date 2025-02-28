-- CREATE PLAYER FRAME BACKDROPS

PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", -190, 240)
PlayerFrameBackdrop:SetSize(124, 48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
PlayerFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
PlayerFrameBackdrop:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
PlayerFrameBackdrop:SetAttribute("unit", "player")
PlayerFrameBackdrop:RegisterForClicks("AnyUp")
PlayerFrameBackdrop:SetAttribute("type1", "target")
PlayerFrameBackdrop:SetAttribute("type2", "togglemenu")

PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48, 48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
PlayerPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
PlayerPortraitBackdrop:SetFrameLevel(PlayerFrame:GetFrameLevel() + 2)
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
    PlayerPVPTimerText:SetAlpha(0)

    PlayerPVPIcon:SetAlpha(0)

    PlayerName:ClearAllPoints()
    PlayerName:SetPoint("TOP", PlayerFrameBackdrop, "TOP", 0, -6)
    PlayerName:SetFont(FONT, MEDIUM, "OUTLINE")
    PlayerName:SetTextColor(unpack(WHITE))

    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
    PlayerLevelText:SetFont(FONT, MEDIUM, "OUTLINE")
    PlayerLevelText:SetTextColor(unpack(WHITE))

    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        PlayerLevelText:Hide()
    else
        PlayerLevelText:Show()
    end

    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(FONT, MEDIUM, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(FONT, MEDIUM, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(FONT, MEDIUM, "OUTLINE")

    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(FONT, 8, "OUTLINE")
end

local PlayerFrameFrame = CreateFrame("Frame")
PlayerFrameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameFrame:SetScript("OnEvent", UpdatePlayerFrame)


-- UPDATE PLAYER RESOURCES

local function UpdatePlayerResources()
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 16)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)
    PlayerFrameHealthBar:SetStatusBarTexture(BAR)
    PlayerFrameHealthBar:SetStatusBarColor(unpack(GREEN))

    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 3)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)
    PlayerFrameManaBar:SetStatusBarTexture(BAR)
    
    local powerType = UnitPowerType("player")
    
    if powerType == 0 then -- Mana
        PlayerFrameManaBar:SetStatusBarColor(unpack(BLUE))
    elseif powerType == 1 then -- Rage
        PlayerFrameManaBar:SetStatusBarColor(unpack(RED))
    elseif powerType == 3 then -- Energy
        PlayerFrameManaBar:SetStatusBarColor(unpack(YELLOW))
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
    PlayerPortrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
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


-- UPDATE PLAYER GROUP ELEMENTS

local function UpdatePlayerGroup()
    if PlayerFrameGroupIndicator then
        PlayerFrameGroupIndicator:SetAlpha(0)
        PlayerFrameGroupIndicator:Hide()
        
        if not PlayerFrameGroupIndicator.hooked then
            hooksecurefunc(PlayerFrameGroupIndicator, "Show", function(self)
                self:SetAlpha(0)
                self:Hide()
            end)
            PlayerFrameGroupIndicator.hooked = true
        end
    end

    local MultiGroupFrame = _G["MultiGroupFrame"]
    if MultiGroupFrame then
        MultiGroupFrame:SetTexture(nil)
        MultiGroupFrame:SetAlpha(0)
        MultiGroupFrame:Hide()
        
        if not MultiGroupFrame.hooked then
            hooksecurefunc(MultiGroupFrame, "Show", function(self)
                self:SetTexture(nil)
                self:SetAlpha(0)
                self:Hide()
            end)
            MultiGroupFrame.hooked = true
        end
    end
end

local PlayerGroupFrame = CreateFrame("Frame")
PlayerGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerGroupFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
PlayerGroupFrame:RegisterEvent("PARTY_LEADER_CHANGED")
PlayerGroupFrame:SetScript("OnEvent", UpdatePlayerGroup)