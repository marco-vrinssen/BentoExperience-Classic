-- ENABLE DRUID MANA BAR

local _, ClassIdentifier = UnitClass("player")

if ClassIdentifier == "DRUID" then

    local DruidManaBarBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBarBackdrop:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    DruidManaBarBackdrop:SetSize(PlayerFrameBackdrop:GetWidth() - 2, 16)
    DruidManaBarBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM, })
    DruidManaBarBackdrop:SetBackdropBorderColor(unpack(GREY))

    local DruidManaBar = CreateFrame("StatusBar", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBar:SetSize(DruidManaBarBackdrop:GetWidth()-4, DruidManaBarBackdrop:GetHeight()-4)
    DruidManaBar:SetPoint("CENTER", DruidManaBarBackdrop, "CENTER", 0, 0)
    DruidManaBar:SetStatusBarTexture(BAR)
    DruidManaBar:SetStatusBarColor(unpack(BLUE))
    DruidManaBar:SetMinMaxValues(0, 1)

    DruidManaBarBackdrop:SetFrameLevel(DruidManaBar:GetFrameLevel() + 2)

    local DruidManaText = DruidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    DruidManaText:SetPoint("CENTER", DruidManaBar, "CENTER", 0, 0)
    DruidManaText:SetTextColor(1, 1, 1)
    DruidManaText:SetFont(GameFontNormal:GetFont(), SMALL, "OUTLINE")

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

    local DruidManaBarFrame = CreateFrame("Frame")
    DruidManaBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    DruidManaBarFrame:RegisterEvent("UNIT_POWER_UPDATE")
    DruidManaBarFrame:RegisterEvent("UNIT_DISPLAYPOWER")
    DruidManaBarFrame:SetScript("OnEvent", DruidManaBarUpdate)
end


-- UPDATE ROGUE COMBO POINTS

local _, ClassIdentifier = UnitClass("player")
if ClassIdentifier ~= "ROGUE" and ClassIdentifier ~= "DRUID" then
    return
end

-- Constants setup

local PointSize = 24
local PointMargin = 4
local PointsTotalWidth = 5 * PointSize + 4 * PointMargin

-- Hide default combo points

local function HideDefaultComboPoints()
    for i = 1, 5 do
        local point = _G["ComboPoint"..i]
        if point then
            point:Hide()
            point:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end

local ComboPointsFrame = CreateFrame("Frame", "ComboPointsFrame", UIParent)
ComboPointsFrame:SetSize(PointsTotalWidth, PointSize)
ComboPointsFrame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 4)

local ComboPoints = {}

-- Create combo point frames

local function CreateComboPoint()
    local cp = CreateFrame("Frame", nil, ComboPointsFrame, "BackdropTemplate")
    cp:SetSize(PointSize, PointSize)
    cp:SetBackdrop({
        bgFile = BG,
        edgeFile = EDGE,
        edgeSize = MEDIUM,
        insets = {left = 2, right = 2, top = 2, bottom = 2}
    })
    cp:SetBackdropBorderColor(unpack(GREY))
    return cp
end

local function ComboPointTextures(cp, active)
    if active then
        cp:SetBackdropColor(unpack(RED))
    else
        cp:SetBackdropColor(unpack(GREY))
    end
end

for i = 1, 5 do
    ComboPoints[i] = CreateComboPoint()
    ComboPointTextures(ComboPoints[i], false)
    ComboPoints[i]:SetPoint("LEFT", ComboPointsFrame, "LEFT", PointSize * (i - 1) + PointMargin * (i - 1), 0)
end

-- Update combo points display

local function ComboPointsUpdate()
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

-- Register events

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
EventFrame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
EventFrame:SetScript("OnEvent", function(self, event, ...)
    ComboPointsUpdate()
    
    -- Hide default combo points initially and after UI reloads
    if event == "PLAYER_ENTERING_WORLD" then
        HideDefaultComboPoints()
    end
end)