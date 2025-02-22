local function CreateCastBarBackdrop()
    local backdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
    backdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
    backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
    backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    backdrop:SetFrameStrata("HIGH")
end

local function UpdateCastBarColor(event)
    if event == "UNIT_SPELLCAST_START" then
        CastingBarFrame:SetStatusBarColor(1, 0.5, 0) -- Yellow
    elseif event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_FAILED" then
        CastingBarFrame:SetStatusBarColor(1, 0, 0) -- Red
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        CastingBarFrame:SetStatusBarColor(0, 1, 0) -- Green
    end
end

local function ConfigureCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 24)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 228)
    CastingBarFrame:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    
    -- Add fade texture to the right side of the text to mask overflow
    local fade = CastingBarFrame:CreateTexture(nil, "OVERLAY")
    fade:SetPoint("TOPRIGHT", CastingBarFrame.Text, "TOPRIGHT", 0, 0)
    fade:SetPoint("BOTTOMRIGHT", CastingBarFrame.Text, "BOTTOMRIGHT", 0, 0)
    fade:SetWidth(25)
    -- Gradient: left side opaque (alpha=1) fading to fully transparent (alpha=0) on right
    fade:SetGradientAlpha("Horizontal", 1,1,1,1, 1,1,1,0)
    fade:Hide()
    CastingBarFrame.Text.fadeTexture = fade
end

local function OnCastBarUpdate(self, elapsed)
    if self.casting and self.maxValue - self.value <= 0.2 then
        self:SetStatusBarColor(0, 1, 0) -- Green
    end
    -- Update fade effect for overflow text
    local textWidth = CastingBarFrame.Text:GetStringWidth()
    if textWidth > CastingBarFrame:GetWidth() then
        CastingBarFrame.Text.fadeTexture:Show()
    else
        CastingBarFrame.Text.fadeTexture:Hide()
    end
end

local function InitializeCastBar()
    CreateCastBarBackdrop()
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