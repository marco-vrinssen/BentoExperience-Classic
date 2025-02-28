-- Update nameplate healthbar

local function NameplateUpdate(Nameplate, unitID)
    local UnitNameplate = Nameplate and Nameplate.UnitFrame
    if not UnitNameplate then return end

    local NameplateHealthbar = UnitNameplate.healthBar
    if not NameplateHealthbar then return end

    local HealthBarTexture = NameplateHealthbar:GetStatusBarTexture()
    HealthBarTexture:SetTexture(BAR)

    if not NameplateHealthbar.CastbarBackdrop then
        NameplateHealthbar.CastbarBackdrop = CreateFrame("Frame", nil, NameplateHealthbar, "BackdropTemplate")
        NameplateHealthbar.CastbarBackdrop:SetPoint("TOPLEFT", NameplateHealthbar, -3, 3)
        NameplateHealthbar.CastbarBackdrop:SetPoint("BOTTOMRIGHT", NameplateHealthbar, 3, -3)
        NameplateHealthbar.CastbarBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
        NameplateHealthbar.CastbarBackdrop:SetBackdropBorderColor(unpack(GREY))
        NameplateHealthbar.CastbarBackdrop:SetFrameLevel(NameplateHealthbar:GetFrameLevel() + 1)
    end

    NameplateHealthbar.border:Hide()
    UnitNameplate.LevelFrame:Hide()

    NameplateHealthbar:ClearAllPoints()
    NameplateHealthbar:SetPoint("CENTER", UnitNameplate, "CENTER", 0, 0)
    NameplateHealthbar:SetWidth(UnitNameplate:GetWidth())

    UnitNameplate.name:ClearAllPoints()
    UnitNameplate.name:SetPoint("BOTTOM", NameplateHealthbar, "TOP", 0, 8)
    UnitNameplate.name:SetFont(FONT, MEDIUM, "OUTLINE")

    if UnitExists(unitID) then
        if UnitIsPlayer(unitID) then
            if UnitIsEnemy("player", unitID) and UnitCanAttack("player", unitID) then
                UnitNameplate.name:SetTextColor(unpack(RED)) -- Red for enemy players that can be attacked
            elseif UnitReaction("player", unitID) == 4 then
                UnitNameplate.name:SetTextColor(unpack(YELLOW)) -- Yellow for neutral players
            else
                UnitNameplate.name:SetTextColor(unpack(WHITE)) -- White for friendly players
            end
        else
            if UnitIsEnemy("player", unitID) and UnitCanAttack("player", unitID) then
                UnitNameplate.name:SetTextColor(unpack(RED)) -- Red for aggressive NPCs
            elseif UnitReaction("player", unitID) == 4 and UnitCanAttack("player", unitID) then
                UnitNameplate.name:SetTextColor(unpack(YELLOW)) -- Yellow for neutral but attackable NPCs
            elseif UnitReaction("player", unitID) >= 4 then
                UnitNameplate.name:SetTextColor(unpack(WHITE)) -- White for friendly NPCs
            end
        end
    end

    UnitNameplate.RaidTargetFrame:ClearAllPoints()
    UnitNameplate.RaidTargetFrame:SetScale(0.8)
    UnitNameplate.RaidTargetFrame:SetPoint("LEFT", NameplateHealthbar, "RIGHT", 4, 2)

    if not NameplateHealthbar.originalColor then
        local r, g, b = NameplateHealthbar:GetStatusBarColor()
        NameplateHealthbar.originalColor = {r, g, b}
    end

    local UnitReaction = UnitReaction(unitID, "player")
    local UnitThreat = UnitThreatSituation("player", unitID)
    local UnitTapState = UnitIsTapDenied(unitID)
    local UnitEnemyPlayer = UnitIsPlayer(unitID) and UnitIsEnemy("player", unitID)

    if UnitTapState then
        NameplateHealthbar:SetStatusBarColor(unpack(GREY))
    elseif UnitEnemyPlayer then
        if UnitCanAttack("player", unitID) then
            NameplateHealthbar:SetStatusBarColor(unpack(RED))
        else
            NameplateHealthbar:SetStatusBarColor(unpack(YELLOW))
        end
    elseif UnitThreat and UnitThreat >= 2 then
        NameplateHealthbar:SetStatusBarColor(unpack(ORANGE))
    elseif UnitReaction then
        if UnitReaction >= 5 then
            NameplateHealthbar:SetStatusBarColor(unpack(GREEN))
        elseif UnitReaction == 4 then
            NameplateHealthbar:SetStatusBarColor(unpack(YELLOW))
        else
            NameplateHealthbar:SetStatusBarColor(unpack(RED))
        end
    else
        local OriginalColor = NameplateHealthbar.originalColor
        NameplateHealthbar:SetStatusBarColor(unpack(OriginalColor))
    end
end

-- Handle nameplate show event

local function NameplateOnShow(Nameplate)
    local unitID = Nameplate.unit
    if unitID then
        NameplateUpdate(Nameplate, unitID)
    end
end

-- Register nameplate events

local NameplateEvents = CreateFrame("Frame")
NameplateEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
NameplateEvents:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
NameplateEvents:SetScript("OnEvent", function(self, event, unitID)
    local Nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if Nameplate then
        NameplateUpdate(Nameplate, unitID)
    end
end)

-- Hook into nameplate update functions

hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
    if frame.unit then
        NameplateUpdate(frame:GetParent(), frame.unit)
    end
end)

hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
    if frame.unit then
        NameplateUpdate(frame:GetParent(), frame.unit)
    end
end)