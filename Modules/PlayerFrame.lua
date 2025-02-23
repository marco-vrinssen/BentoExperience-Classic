-- Player Frame Backdrop Setup
PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", -190, 224)
PlayerFrameBackdrop:SetSize(124, 48)
PlayerFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
PlayerFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerFrameBackdrop:SetFrameStrata("HIGH")
PlayerFrameBackdrop:SetAttribute("unit", "player")
PlayerFrameBackdrop:RegisterForClicks("AnyUp")
PlayerFrameBackdrop:SetAttribute("type1", "target")
PlayerFrameBackdrop:SetAttribute("type2", "togglemenu")

-- Player Portrait Backdrop Setup
PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48, 48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
PlayerPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerPortraitBackdrop:SetFrameStrata("HIGH")
PlayerPortraitBackdrop:SetAttribute("unit", "player")
PlayerPortraitBackdrop:RegisterForClicks("AnyUp")
PlayerPortraitBackdrop:SetAttribute("type1", "target")
PlayerPortraitBackdrop:SetAttribute("type2", "togglemenu")

-- Player Frame Update Function
local function UpdatePlayerFrame()
	-- Position and sizing updates
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
    PlayerName:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerName:SetTextColor(1, 1, 1, 1)
end

-- Event Registrations for Player Frame
local PlayerFrameEvents = CreateFrame("Frame")
PlayerFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameEvents:SetScript("OnEvent", UpdatePlayerFrame)

-- Player Resource Update Function
local function UpdatePlayerResource()
    -- Update player health bar
    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 16)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)
    PlayerFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    -- Update player mana bar
    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 4)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)
    PlayerFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    -- Update health bar text
    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

    -- Update mana bar text
    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
end

-- Player Resource Events
local PlayerResourceEvents = CreateFrame("Frame")
PlayerResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerResourceEvents:RegisterEvent("UNIT_MANA")
PlayerResourceEvents:RegisterEvent("UNIT_HEALTH")
PlayerResourceEvents:SetScript("OnEvent", function(self, event, arg1)
    if event == "PLAYER_ENTERING_WORLD" or (arg1 == "player" and (event == "UNIT_MANA" or event == "UNIT_HEALTH")) then
        UpdatePlayerResource()
    end
end)

-- Player Portrait Update Function
local function PlayerPortraitUpdate()
    PlayerPortrait:ClearAllPoints()
    PlayerPortrait:SetPoint("CENTER", PlayerPortraitBackdrop, "CENTER", 0, 0)
    PlayerPortrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
    PlayerPortrait:SetSize(PlayerPortraitBackdrop:GetHeight()-6, PlayerPortraitBackdrop:GetHeight()-6)
    
    PlayerFrame:UnregisterEvent("UNIT_COMBAT")

    PlayerLeaderIcon:ClearAllPoints()
    PlayerLeaderIcon:SetPoint("BOTTOM", PlayerPortraitBackdrop, "TOP", 0, 0)

    PlayerMasterIcon:ClearAllPoints()
    PlayerMasterIcon:SetPoint("BOTTOM", PlayerLeaderIcon, "TOP", 0, 0)
    PlayerMasterIcon:SetScale(0.75)

    PlayerPVPTimerText:ClearAllPoints()
    PlayerPVPTimerText:SetPoint("TOPRIGHT", PlayerPortraitBackdrop, "TOPLEFT", -4, 0)
    PlayerPVPTimerText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerPVPTimerText:SetTextColor(1, 1, 1, 1)
end

-- Player Portrait Events
local PlayerPortraitEvents = CreateFrame("Frame")
PlayerPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerPortraitEvents:SetScript("OnEvent", PlayerPortraitUpdate)

-- Player Group Update Function
local function UpdateGroupElements()
    PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerFrameGroupIndicator:Hide()

    local MultiGroupFrame = _G["MultiGroupFrame"]
    if MultiGroupFrame then
        MultiGroupFrame:SetTexture(nil)
        MultiGroupFrame:SetAlpha(0)
        MultiGroupFrame:Hide()
    end
end

-- Hook Group Elements Update
if _G["MultiGroupFrame"] then
    MultiGroupFrame:HookScript("OnShow", UpdateGroupElements)
end

PlayerFrameGroupIndicator:HookScript("OnShow", UpdateGroupElements)

-- Player Group Events
local PlayerGroupEvents = CreateFrame("Frame")
PlayerGroupEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerGroupEvents:SetScript("OnEvent", UpdateGroupElements)

-- Player Level Update Function
local function PlayerLevelUpdate()
    PlayerLevelText:ClearAllPoints()
    PlayerLevelText:SetPoint("TOP", PlayerPortraitBackdrop, "BOTTOM", 0, -4)
    PlayerLevelText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerLevelText:SetTextColor(1, 1, 1, 1)

    if UnitLevel("player") < MAX_PLAYER_LEVEL then
        PlayerLevelText:Show()
    else
        PlayerLevelText:Hide()
    end
end

-- Player Level Events
local PlayerLevelEvents = CreateFrame("Frame")
PlayerLevelEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerLevelEvents:RegisterEvent("PLAYER_LEVEL_UP")
PlayerLevelEvents:RegisterEvent("PLAYER_XP_UPDATE")
PlayerLevelEvents:SetScript("OnEvent", PlayerLevelUpdate)