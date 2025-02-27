-- CREATE CASTBAR BACKDROP

local CastingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
CastingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
CastingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
CastingBarBackdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
CastingBarBackdrop:SetBackdropBorderColor(unpack(N.RGB))
CastingBarBackdrop:SetFrameStrata("HIGH")


-- UPDATE CASTBAR

local function UpdateCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetSize(160, 24)
    CastingBarFrame:SetMovable(true)
    CastingBarFrame:SetUserPlaced(true)
    CastingBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 240)
    CastingBarFrame:SetStatusBarTexture(T.BAR)
    CastingBarFrame.Border:Hide()
    CastingBarFrame.Spark:SetTexture(nil)
    CastingBarFrame.Flash:SetTexture(nil)
    CastingBarFrame.Text:ClearAllPoints()
    CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, "CENTER", 0, 0)
    CastingBarFrame.Text:SetFont(F.TYPE, F.SIZE, "OUTLINE")
end

local function RecolorCastBar(event)
    if event == "UNIT_SPELLCAST_START" then
        CastingBarFrame:SetStatusBarColor(unpack(Y.RGB))
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