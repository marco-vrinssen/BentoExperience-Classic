
-- Setup nameplate castbar

local function NameplateCastbarSetup(Nameplate)
    local HealthbarReference = Nameplate.UnitFrame.healthBar

    local NameplateCastbar = CreateFrame("StatusBar", nil, Nameplate)
    NameplateCastbar:SetStatusBarTexture(BAR)
    NameplateCastbar:SetStatusBarColor(unpack(YELLOW))
    NameplateCastbar:SetSize(HealthbarReference:GetWidth(), 10)
    NameplateCastbar:SetPoint("TOP", HealthbarReference, "BOTTOM", 0, -5)
    NameplateCastbar:SetMinMaxValues(0, 1)
    NameplateCastbar:SetValue(0)

    local CastbarBackdrop = CreateFrame("Frame", nil, NameplateCastbar, "BackdropTemplate")
    CastbarBackdrop:SetPoint("TOPLEFT", NameplateCastbar, -2, 2)
    CastbarBackdrop:SetPoint("BOTTOMRIGHT", NameplateCastbar, 2, -2)
    CastbarBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = 10})
    CastbarBackdrop:SetBackdropBorderColor(unpack(GREY))
    CastbarBackdrop:SetFrameLevel(NameplateCastbar:GetFrameLevel() + 1)

    local CastbarText = NameplateCastbar:CreateFontString(nil, "OVERLAY")
    CastbarText:SetFont(FONT, 8, "OUTLINE")
    CastbarText:SetPoint("CENTER", NameplateCastbar)

    NameplateCastbar.CastbarBackdrop = CastbarBackdrop
    NameplateCastbar.CastbarText = CastbarText
    NameplateCastbar:Hide()

    return NameplateCastbar
end

-- Update nameplate castbar

local function NameplateCastbarUpdate(NameplateCastbar, Unit)
    local name, _, _, startTime, endTime, _, _, SpellInterruptible = UnitCastingInfo(Unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(Unit)

    if name or channelName then
        local CastDuration = (endTime or channelEndTime) / 1000
        local CurrentTimer = GetTime()

        NameplateCastbar:SetMinMaxValues((startTime or channelStartTime) / 1000, CastDuration)
        NameplateCastbar:SetValue(CurrentTimer)

        if SpellInterruptible then
            NameplateCastbar:SetStatusBarColor(unpack(GREY))
        else
            NameplateCastbar:SetStatusBarColor(unpack(YELLOW))
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

-- Handle castbar animation updates

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

-- Register castbar events

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