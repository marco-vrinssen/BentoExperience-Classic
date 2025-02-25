local function NameplateUpdate(Nameplate, unitID)
    local UnitNameplate = Nameplate and Nameplate.UnitFrame
    if not UnitNameplate then return end

    NameplateHealthbar = UnitNameplate.healthBar
    if not NameplateHealthbar then return end

    local HealthBarTexture = NameplateHealthbar:GetStatusBarTexture()
    HealthBarTexture:SetTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    if not NameplateHealthbar.CastbarBackdrop then
        NameplateHealthbar.CastbarBackdrop = CreateFrame("Frame", nil, NameplateHealthbar, "BackdropTemplate")
        NameplateHealthbar.CastbarBackdrop:SetPoint("TOPLEFT", NameplateHealthbar, -3, 3)
        NameplateHealthbar.CastbarBackdrop:SetPoint("BOTTOMRIGHT", NameplateHealthbar, 3, -3)
        NameplateHealthbar.CastbarBackdrop:SetFrameStrata("HIGH")
        NameplateHealthbar.CastbarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
        NameplateHealthbar.CastbarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    end

    NameplateHealthbar.border:Hide()
    UnitNameplate.LevelFrame:Hide()

    NameplateHealthbar:ClearAllPoints()
    NameplateHealthbar:SetPoint("CENTER", UnitNameplate, "CENTER", 0, 0)
    NameplateHealthbar:SetWidth(UnitNameplate:GetWidth())

    UnitNameplate.name:ClearAllPoints()
    UnitNameplate.name:SetPoint("BOTTOM", NameplateHealthbar, "TOP", 0, 8)
    UnitNameplate.name:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

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
        NameplateHealthbar:SetStatusBarColor(0.5, 0.5, 0.5)
    elseif UnitEnemyPlayer then
        if UnitCanAttack("player", unitID) then
            NameplateHealthbar:SetStatusBarColor(1, 0, 0)
        else
            NameplateHealthbar:SetStatusBarColor(1, 1, 0)
        end
    elseif UnitThreat and UnitThreat >= 2 then
        NameplateHealthbar:SetStatusBarColor(1, 0.5, 0)
    elseif UnitReaction then
        if UnitReaction >= 5 then
            NameplateHealthbar:SetStatusBarColor(0, 1, 0)
        elseif UnitReaction == 4 then
            NameplateHealthbar:SetStatusBarColor(1, 1, 0)
        else
            NameplateHealthbar:SetStatusBarColor(1, 0, 0)
        end
    else
        local OriginalColor = NameplateHealthbar.originalColor
        NameplateHealthbar:SetStatusBarColor(unpack(OriginalColor))
    end
end

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

local function NameplateCastbarSetup(Nameplate)
    local HealthbarReference = Nameplate.UnitFrame.healthBar

    local NameplateCastbar = CreateFrame("StatusBar", nil, Nameplate)
    NameplateCastbar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill")
    NameplateCastbar:SetSize(HealthbarReference:GetWidth(), 10)
    NameplateCastbar:SetPoint("TOP", HealthbarReference, "BOTTOM", 0, -5)
    NameplateCastbar:SetMinMaxValues(0, 1)
    NameplateCastbar:SetValue(0)

    local CastbarBackdrop = CreateFrame("Frame", nil, NameplateCastbar, "BackdropTemplate")
    CastbarBackdrop:SetPoint("TOPLEFT", NameplateCastbar, -2, 2)
    CastbarBackdrop:SetPoint("BOTTOMRIGHT", NameplateCastbar, 2, -2)
    CastbarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 10})
    CastbarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
    CastbarBackdrop:SetFrameLevel(NameplateCastbar:GetFrameLevel() + 1)

    local CastbarText = NameplateCastbar:CreateFontString(nil, "OVERLAY")
    CastbarText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    CastbarText:SetPoint("CENTER", NameplateCastbar)

    NameplateCastbar.CastbarBackdrop = CastbarBackdrop
    NameplateCastbar.CastbarText = CastbarText
    NameplateCastbar:Hide()

    return NameplateCastbar
end

local function NameplateCastbarUpdate(NameplateCastbar, Unit)
    local name, _, _, startTime, endTime, _, _, SpellInterruptible = UnitCastingInfo(Unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(Unit)

    if name or channelName then
        local CastDuration = (endTime or channelEndTime) / 1000
        local CurrentTimer = GetTime()

        NameplateCastbar:SetMinMaxValues((startTime or channelStartTime) / 1000, CastDuration)
        NameplateCastbar:SetValue(CurrentTimer)

        if SpellInterruptible then
            NameplateCastbar:SetStatusBarColor(0.5, 0.5, 0.5)
        else
            NameplateCastbar:SetStatusBarColor(0, 1, 0)
        end

        NameplateCastbar.casting = name ~= nil
        NameplateCastbar.channeling = channelName ~= nil
        NameplateCastbar.maxValue = CastDuration
        NameplateCastbar.CastbarText:SetText(name or channelName)
        NameplateCastbar:Show()
        NameplateCastbar.CastbarBackdrop:Show()
    else
        NameplateCastbar:Hide()
        NameplateCastbar.CastbarBackdrop:Hide()
    end
end

local function OnUpdate(self, elapsed)
    if self.casting or self.channeling then
        local CurrentTimer = GetTime()
        if CurrentTimer > self.maxValue then
            self:SetValue(self.maxValue)
            self.casting = false
            self.channeling = false
            self:Hide()
            self.CastbarBackdrop:Hide()
        else
            self:SetValue(CurrentTimer)
            self.CastbarBackdrop:Show()
        end
    end
end

local NameplateCastbarEvents = CreateFrame("Frame")
NameplateCastbarEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_START")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
NameplateCastbarEvents:SetScript("OnEvent", function(self, event, unitID)
    local Nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if Nameplate then
        if not Nameplate.NameplateCastbar then
            Nameplate.NameplateCastbar = NameplateCastbarSetup(Nameplate)
            Nameplate.NameplateCastbar:SetScript("OnUpdate", OnUpdate)
        end
        NameplateCastbarUpdate(Nameplate.NameplateCastbar, unitID)
    end
end)

local function NameplateConfigUpdate()
    SetCVar("nameplateMinScale", 0.8)
end

local NameplateConfigEvents = CreateFrame("Frame")
NameplateConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
NameplateConfigEvents:SetScript("OnEvent", NameplateConfigUpdate)