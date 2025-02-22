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




local PlayerPortraitBackdrop = CreateFrame("Button", nil, PlayerFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PlayerPortraitBackdrop:SetPoint("RIGHT", PlayerFrameBackdrop, "LEFT", 0, 0)
PlayerPortraitBackdrop:SetSize(48 ,48)
PlayerPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
PlayerPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PlayerPortraitBackdrop:SetFrameStrata("HIGH")

PlayerPortraitBackdrop:SetAttribute("unit", "player")
PlayerPortraitBackdrop:RegisterForClicks("AnyUp")
PlayerPortraitBackdrop:SetAttribute("type1", "target")
PlayerPortraitBackdrop:SetAttribute("type2", "togglemenu")




-- New: SmoothStatusBar function to animate status bar changes
local function SmoothStatusBar(statusBar, targetValue)
    statusBar.smooth = statusBar.smooth or statusBar:GetValue()
    statusBar:SetScript("OnUpdate", function(self, elapsed)
        self.smooth = self.smooth + (targetValue - self.smooth) * elapsed * 4  -- multiplier adjusts speed
        self:SetValue(self.smooth)
        if math.abs(targetValue - self.smooth) < 0.1 then
            self:SetValue(targetValue)
            self.smooth = targetValue
            self:SetScript("OnUpdate", nil)
        end
    end)
end

local function PlayerFrameUpdate()
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
    PlayerName:SetFont(STANDARD_TEXT_FONT, 12)
    PlayerName:SetTextColor(1, 1, 1, 1)

    PlayerFrameHealthBar:ClearAllPoints()
    PlayerFrameHealthBar:SetSize(PlayerFrameBackground:GetWidth(), 16)
    PlayerFrameHealthBar:SetPoint("BOTTOM", PlayerFrameManaBar, "TOP", 0, 0)
    PlayerFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    
    PlayerFrameManaBar:ClearAllPoints()
    PlayerFrameManaBar:SetPoint("BOTTOM", PlayerFrameBackdrop, "BOTTOM", 0, 4)
    PlayerFrameManaBar:SetSize(PlayerFrameBackground:GetWidth(), 8)
    PlayerFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
    PlayerFrameHealthBarText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextRight:SetPoint("RIGHT", PlayerFrameHealthBar, "RIGHT", -4, 0)
    PlayerFrameHealthBarTextRight:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    PlayerFrameHealthBarTextLeft:SetPoint("LEFT", PlayerFrameHealthBar, "LEFT", 4, 0)
    PlayerFrameHealthBarTextLeft:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

    PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    PlayerFrameManaBarText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextLeft:SetPoint("LEFT", PlayerFrameManaBar, "LEFT", 4, 0)
    PlayerFrameManaBarTextLeft:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    PlayerFrameManaBarTextRight:SetPoint("RIGHT", PlayerFrameManaBar, "RIGHT", -4, 0)
    PlayerFrameManaBarTextRight:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    
    local newHealth = UnitHealth("player")
    local maxHealth = UnitHealthMax("player")
    PlayerFrameHealthBar:SetMinMaxValues(0, maxHealth)
    SmoothStatusBar(PlayerFrameHealthBar, newHealth)
    
    local newMana = UnitPower("player", Enum.PowerType.Mana)
    local maxMana = UnitPowerMax("player", Enum.PowerType.Mana)
    PlayerFrameManaBar:SetMinMaxValues(0, maxMana)
    SmoothStatusBar(PlayerFrameManaBar, newMana)
end

local PlayerFrameEvents = CreateFrame("Frame")
PlayerFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerFrameEvents:RegisterEvent("PLAYER_REGEN_DISABLED")
PlayerFrameEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
PlayerFrameEvents:RegisterEvent("UNIT_POWER_UPDATE")
PlayerFrameEvents:RegisterEvent("UNIT_DISPLAYPOWER")
PlayerFrameEvents:RegisterEvent("UPDATE_EXHAUSTION")
PlayerFrameEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_REGEN_DISABLED" then
        self.inCombat = true
    elseif event == "PLAYER_REGEN_ENABLED" then
        self.inCombat = false
        PlayerFrameUpdate()
    else
        PlayerFrameUpdate()
    end
end)



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

local PlayerPortraitEvents = CreateFrame("Frame")
PlayerPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerPortraitEvents:SetScript("OnEvent", PlayerPortraitUpdate)




local function PlayerGroupUpdate()
    PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerFrameGroupIndicator:Hide()

    local MultiGroupFrame = _G["MultiGroupFrame"]
    if MultiGroupFrame then
        MultiGroupFrame:SetTexture(nil)
        MultiGroupFrame:SetAlpha(0)
        MultiGroupFrame:Hide()
    end
end

if _G["MultiGroupFrame"] then
    MultiGroupFrame:HookScript("OnShow", PlayerGroupUpdate)
end

PlayerFrameGroupIndicator:HookScript("OnShow", PlayerGroupUpdate)

local PlayerGroupEvents = CreateFrame("Frame")
PlayerGroupEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerGroupEvents:SetScript("OnEvent", PlayerGroupUpdate)




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

local PlayerLevelEvents = CreateFrame("Frame")
PlayerLevelEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerLevelEvents:RegisterEvent("PLAYER_LEVEL_UP")
PlayerLevelEvents:RegisterEvent("PLAYER_XP_UPDATE")
PlayerLevelEvents:SetScript("OnEvent", PlayerLevelUpdate)




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

local function PetFrameUpdate()
    PetFrame:ClearAllPoints()
    PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)

    PetFrameTexture:Hide()
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

    PetPortrait:Hide()
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

hooksecurefunc("PetFrame_Update", PetFrameUpdate)

local PetFrameEvents = CreateFrame("Frame")
PetFrameEvents:RegisterEvent("UNIT_PET")
PetFrameEvents:RegisterEvent("PET_UI_UPDATE")
PetFrameEvents:SetScript("OnEvent", PetFrameUpdate)










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
    local ComboPoint = CreateFrame("Frame", nil, ComboPointsFrame, "BackdropTemplate")
    ComboPoint:SetSize(PointSize, PointSize)
    ComboPoint:SetBackdrop({
        bgFile = "Interface/ChatFrame/ChatFrameBackground",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = false,
        tileSize = 16,
        edgeSize = 12,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    ComboPoint:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    ComboPoint:SetBackdropColor(0, 0, 0, 0.5)
    return ComboPoint
end

local function ComboPointTextures(ComboPoint, ActiveState)
    if ActiveState then
        ComboPoint:SetBackdropColor(0.75, 0, 0, 1)
    else
        ComboPoint:SetBackdropColor(0, 0, 0, 0.5)
    end
end

for i = 1, 5 do
    local ComboPoint = CreateComboPoint()
    ComboPointTextures(ComboPoint, false)
    ComboPoints[i] = ComboPoint
end

ComboPointsFrame:SetWidth(PointSize * 5 + PointMargin * 4)
for i, ComboPoint in ipairs(ComboPoints) do
    ComboPoint:SetPoint("LEFT", ComboPointsFrame, "LEFT", PointSize * (i - 1) + PointMargin * (i - 1), 0)
end

local function ComboPointsUpdate()
    ComboFrame:UnregisterAllEvents()
    ComboFrame:Hide()

    local ComboPointsCount = GetComboPoints("player", "target") or 0
    if ComboPointsCount > 0 then
        ComboPointsFrame:Show()
        for i = 1, 5 do
            ComboPointTextures(ComboPoints[i], i <= ComboPointsCount)
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