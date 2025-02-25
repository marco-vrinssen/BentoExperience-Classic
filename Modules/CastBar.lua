local CastingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
CastingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
CastingBarBackdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12 })
CastingBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
CastingBarBackdrop:SetFrameStrata("HIGH")


local function UpdateCastBar()
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
end  


local StateColors = {
    UNIT_SPELLCAST_START = {0.5, 0.5, 1}
}


local function RecolorCastBar(event)
    local CastStateColor = StateColors[event]
    if CastStateColor then
        CastingBarFrame:SetStatusBarColor(unpack(CastStateColor))
    end
end  


local CastBarEvents = CreateFrame("Frame")
CastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_START")
CastBarEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
CastBarEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        UpdateCastBar()
    else
        RecolorCastBar(event)
    end
end)