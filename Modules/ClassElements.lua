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