-- CREATE CASTBAR BACKDROP

local castingBarBackdrop = CreateFrame("Frame", nil, CastingBarFrame, "BackdropTemplate")
castingBarBackdrop:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", -3, 3)
castingBarBackdrop:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", 3, -3)
castingBarBackdrop:SetBackdrop({ edgeFile = BORD, edgeSize = 12})
castingBarBackdrop:SetBackdropBorderColor(unpack(GREY_UI))
castingBarBackdrop:SetFrameLevel(CastingBarFrame:GetFrameLevel() + 2)


-- UPDATE CASTBAR

local function updateCastBar()
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
    CastingBarFrame.Text:SetPoint("TOPLEFT", CastingBarFrame, "TOPLEFT", 4, -4)
    CastingBarFrame.Text:SetPoint("BOTTOMRIGHT", CastingBarFrame, "BOTTOMRIGHT", -4, 4)
    CastingBarFrame.Text:SetFont(FONT, 12, "OUTLINE")
end


-- RECOLOR CASTBAR ON EVENTS

local function recolorCastBar(event)
    if event == "UNIT_SPELLCAST_START" then
        CastingBarFrame:SetStatusBarColor(unpack(YELLOW_UI))
    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_FAILED" then
        CastingBarFrame:SetStatusBarColor(unpack(RED_UI))
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        CastingBarFrame:SetStatusBarColor(unpack(GREEN_UI))
    end
end  


-- INITIALIZE CASTBAR FRAME

local castBarEvents = CreateFrame("Frame")
castBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_START")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_FAILED")
castBarEvents:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
castBarEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        updateCastBar()
    else
        recolorCastBar(event)
    end
end)