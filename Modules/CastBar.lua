-- Backdrop Initialization for CastingBar
local CastingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
CastingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
CastingBarBackdrop:SetBackdrop({
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 12
})
CastingBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CastingBarBackdrop:SetFrameStrata("HIGH")

-- Configure Cast Bar Properties
local function ConfigureCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 24)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 228)
    CastingBarFrame:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    -- Remove unwanted visual elements
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)

    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
end

-- Event Colors Mapping
local eventColors = {
    UNIT_SPELLCAST_START       = {1, 0.25, 0},  -- Yellow (changed from original orange)
    UNIT_SPELLCAST_INTERRUPTED = {1, 0, 0},     -- Red
    UNIT_SPELLCAST_FAILED      = {1, 0, 0},     -- Red
    UNIT_SPELLCAST_SUCCEEDED   = {0, 1, 0}      -- Green
}

-- Update Cast Bar Color based on Spell Events
local function UpdateCastBarColor(event)
    local CastStateColor = eventColors[event]
    if CastStateColor then
        CastingBarFrame:SetStatusBarColor(unpack(CastStateColor))
    end
end

-- Initialize Cast Bar by configuring its properties
local function InitializeCastBar()
    ConfigureCastBar()
end

-- Register Events & Setup Event Handling
local CastBarEvents = CreateFrame("Frame")
CastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_START")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_FAILED")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
CastBarEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        InitializeCastBar()
    else
        UpdateCastBarColor(event)
    end
end)