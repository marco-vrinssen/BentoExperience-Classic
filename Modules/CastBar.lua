-- CREATE CASTBAR BACKDROP

local CastingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
CastingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
CastingBarBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM})
CastingBarBackdrop:SetBackdropBorderColor(unpack(GREY))
CastingBarBackdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)


-- UPDATE CASTBAR

local function UpdateCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 20)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 242)
    CastingBarFrame:SetStatusBarTexture(BAR)
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(FONT, MEDIUM, "OUTLINE")
end

local function RecolorCastBar(event)
    if event == "UNIT_SPELLCAST_START" then
        CastingBarFrame:SetStatusBarColor(unpack(YELLOW))
    end
end  

local CastBarFrame = CreateFrame("Frame")
CastBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
CastBarFrame:RegisterEvent("UNIT_SPELLCAST_START")
CastBarFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        UpdateCastBar()
    else
        RecolorCastBar(event)
    end
end)