local function ConfigureCastBar()
    -- Set up position, size, textures, etc.
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 24)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 228)
    CastingBarFrame:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    
    -- Create backdrop (inlined from CreateCastBarBackdrop)
    local backdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
    backdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
    backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
    backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    backdrop:SetFrameStrata("HIGH")
    
    -- Remove unwanted elements
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
end

-- Simplified color update using a lookup table
local eventColors = {
    UNIT_SPELLCAST_START    = {1, 0.5, 0},  -- Yellow
    UNIT_SPELLCAST_INTERRUPTED = {1, 0, 0}, -- Red
    UNIT_SPELLCAST_FAILED      = {1, 0, 0}, -- Red
    UNIT_SPELLCAST_SUCCEEDED   = {0, 1, 0}  -- Green
}

local function UpdateCastBarColor(event)
    local color = eventColors[event]
    if color then
        CastingBarFrame:SetStatusBarColor(unpack(color))
    end
end

local function InitializeCastBar()
    ConfigureCastBar()
    CastingBarFrame:HookScript("OnUpdate", OnCastBarUpdate)
end

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