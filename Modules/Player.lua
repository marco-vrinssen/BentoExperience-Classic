-- Player Frame Backdrop Setup
local PlayerFrameBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
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
local PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
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











-- Setup backdrop for the pet frame
local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12})
PetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PetFrameBackdrop:SetFrameStrata("HIGH")
PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")


-- Update pet frame properties
local function UpdatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)
	PetFrame:SetSize(PetFrameBackdrop:GetWidth(), PetFrameBackdrop:GetHeight())
    
    PetFrameTexture:Hide()

    PetPortrait:Hide()
	PetAttackModeTexture:SetTexture(nil)

    PetName:Hide()
	
	PetFrameHealthBar:ClearAllPoints()
	PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
	PetFrameHealthBar:SetPoint("TOP", PetFrameBackdrop, "TOP", 0, -2)
	PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
	PetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
	
	PetFrameManaBar:ClearAllPoints()
	PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
	PetFrameManaBar:SetHeight(8)
	PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
	PetFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
	
	PetFrameHealthBarText:SetAlpha(0)
	PetFrameHealthBarTextLeft:SetAlpha(0)
	PetFrameHealthBarTextRight:SetAlpha(0)
	PetFrameManaBarText:SetAlpha(0)
	PetFrameManaBarTextLeft:SetAlpha(0)
	PetFrameManaBarTextRight:SetAlpha(0)
	

	PetFrame:UnregisterEvent("UNIT_COMBAT")
	
	PetFrameHappiness:ClearAllPoints()
	PetFrameHappiness:SetPoint("RIGHT", PetFrameBackdrop, "LEFT", 0, 0)
	
	for i = 1, MAX_TARGET_BUFFS do
		local PetBuff = _G["PetFrameBuff" .. i]
		if PetBuff then
			PetBuff:SetAlpha(0)
		end
	end
	
	for i = 1, MAX_TARGET_DEBUFFS do
		local PetDebuff = _G["PetFrameDebuff" .. i]
		if PetDebuff then
			PetDebuff:SetAlpha(0)
		end
	end
end

-- Setup pet frame event listener
local PetFrameEvents = CreateFrame("Frame")
PetFrameEvents:RegisterEvent("UNIT_PET")
PetFrameEvents:SetScript("OnEvent", UpdatePetFrame)











-- Druid Mana Bar Setup (for DRUID class only)
local _, ClassIdentifier = UnitClass("player")

if ClassIdentifier == "DRUID" then

    local DruidManaBarBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBarBackdrop:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    DruidManaBarBackdrop:SetSize(PlayerFrameBackdrop:GetWidth() - 2, 20)
    DruidManaBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12, })
    DruidManaBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

    local DruidManaBar = CreateFrame("StatusBar", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBar:SetSize(DruidManaBarBackdrop:GetWidth()-4, DruidManaBarBackdrop:GetHeight()-4)
    DruidManaBar:SetPoint("CENTER", DruidManaBarBackdrop, "CENTER", 0, 0)
    DruidManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    DruidManaBar:SetStatusBarColor(0, 0.25, 1)
    DruidManaBar:SetMinMaxValues(0, 1)

    DruidManaBarBackdrop:SetFrameLevel(DruidManaBar:GetFrameLevel() + 1)

    local DruidManaText = DruidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    DruidManaText:SetPoint("CENTER", DruidManaBar, "CENTER", 0, 0)
    DruidManaText:SetTextColor(1, 1, 1)
    DruidManaText:SetFont(GameFontNormal:GetFont(), 10)

    local function DruidManaBarUpdate()
        local PlayerPowerType, PowerToken = UnitPowerType("player")
        local PlayerForm = GetShapeshiftFormID()
    
        if PlayerForm and PowerToken ~= "MANA" then
            local PlayerMana = UnitPower("player", Enum.PowerType.Mana)
            local PlayerMaxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            DruidManaBar:SetValue(PlayerMana / PlayerMaxMana)
            DruidManaText:SetText(PlayerMana .. " / " .. PlayerMaxMana)
            DruidManaBar:Show()
            DruidManaBarBackdrop:Show()
        else
            DruidManaBar:Hide()
            DruidManaBarBackdrop:Hide()
        end
    end

    local DruidManaBarEvents = CreateFrame("Frame")
    DruidManaBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
    DruidManaBarEvents:RegisterEvent("UNIT_POWER_UPDATE")
    DruidManaBarEvents:RegisterEvent("UNIT_DISPLAYPOWER")
    DruidManaBarEvents:SetScript("OnEvent", DruidManaBarUpdate)
end




-- Combo Points Frame Setup (for ROGUE/DRUID only)
local _, ClassIdentifier = UnitClass("player")
if ClassIdentifier ~= "ROGUE" and ClassIdentifier ~= "DRUID" then
    return
end

local PointSize = 24
local PointMargin = 4
local PointsTotalWidth = 5 * PointSize + 4 * PointMargin

local ComboPointsFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
ComboPointsFrame:SetSize(PointsTotalWidth, PointSize)
ComboPointsFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)

local ComboPoints = {}

local function CreateComboPoint()
    local cp = CreateFrame("Frame", nil, ComboPointsFrame, "BackdropTemplate")
    cp:SetSize(PointSize, PointSize)
    cp:SetBackdrop({
        bgFile = "Interface/ChatFrame/ChatFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = false,
        tileSize = 16,
        edgeSize = 12,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    cp:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    cp:SetBackdropColor(0, 0, 0, 0.5)
    return cp
end

local function ComboPointTextures(cp, active)
    if active then
        cp:SetBackdropColor(0.75, 0, 0, 1)
    else
        cp:SetBackdropColor(0, 0, 0, 0.5)
    end
end

for i = 1, 5 do
    ComboPoints[i] = CreateComboPoint()
    ComboPointTextures(ComboPoints[i], false)
    ComboPoints[i]:SetPoint("LEFT", ComboPointsFrame, "LEFT", PointSize * (i - 1) + PointMargin * (i - 1), 0)
end

local function ComboPointsUpdate()
    ComboFrame:UnregisterAllEvents()
    ComboFrame:Hide()
    local count = GetComboPoints("player", "target") or 0
    if count > 0 then
        ComboPointsFrame:Show()
        for i = 1, 5 do
            ComboPointTextures(ComboPoints[i], i <= count)
        end
    else
        ComboPointsFrame:Hide()
    end
end

local ComboPointsEvents = CreateFrame("Frame")
ComboPointsEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ComboPointsEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
ComboPointsEvents:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
ComboPointsEvents:SetScript("OnEvent", ComboPointsUpdate)