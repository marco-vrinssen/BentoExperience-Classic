-- SETUP NAMEPLATE APPEARANCE

local function CreateBackdrop(parent)
    local backdrop = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", parent, "TOPLEFT", -3, 3)
    backdrop:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 3, -3)
    backdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
    backdrop:SetBackdropBorderColor(unpack(GREY))
    backdrop:SetFrameStrata("HIGH")
    return backdrop
end


-- HANDLE CASTBAR ANIMATION UPDATES

local function OnUpdate(self, elapsed)
    if self.casting or self.channeling then
        local CurrentTimer = GetTime()
        if CurrentTimer > self.maxValue then
            self:SetValue(self.maxValue)
            self.casting = false
            self.channeling = false
            self:Hide()
        else
            self:SetValue(CurrentTimer)
        end
    end
end


-- SETUP NAMEPLATE CASTBAR

local function NameplateCastbarSetup(Nameplate)
    local HealthbarReference = Nameplate.UnitFrame.healthBar

    local NamePlateCastBar = CreateFrame("StatusBar", nil, Nameplate)
    NamePlateCastBar:SetStatusBarTexture(BAR)
    NamePlateCastBar:SetStatusBarColor(unpack(YELLOW))
    NamePlateCastBar:SetSize(HealthbarReference:GetWidth(), 10)
    -- Change this line to create 4px margin between healthbar and castbar
    NamePlateCastBar:SetPoint("TOP", HealthbarReference, "BOTTOM", 0, -4)
    NamePlateCastBar:SetMinMaxValues(0, 1)
    NamePlateCastBar:SetValue(0)

    -- Use the same backdrop style as the healthbar
    NamePlateCastBar.backdrop = CreateBackdrop(NamePlateCastBar)

    local CastBarText = NamePlateCastBar:CreateFontString(nil, "OVERLAY")
    CastBarText:SetFont(FONT, 8, "OUTLINE")
    CastBarText:SetPoint("CENTER", NamePlateCastBar)

    NamePlateCastBar.CastBarText = CastBarText
    NamePlateCastBar:Hide()

    return NamePlateCastBar
end


-- UPDATE NAMEPLATE CASTBAR

local function UpdateNamePlateCastBar(NamePlateCastBar, Unit)
    if not NamePlateCastBar or not Unit then return end
    
    local name, _, _, startTime, endTime, _, _, SpellInterruptible = UnitCastingInfo(Unit)
    local channelName, _, _, channelStartTime, channelEndTime = UnitChannelInfo(Unit)

    if name or channelName then
        local CastDuration = (endTime or channelEndTime) / 1000
        local CurrentTimer = GetTime()

        NamePlateCastBar:SetMinMaxValues((startTime or channelStartTime) / 1000, CastDuration)
        NamePlateCastBar:SetValue(CurrentTimer)

        if SpellInterruptible then
            NamePlateCastBar:SetStatusBarColor(unpack(GREY))
        else
            NamePlateCastBar:SetStatusBarColor(unpack(YELLOW))
        end

        NamePlateCastBar.casting = name ~= nil
        NamePlateCastBar.channeling = channelName ~= nil
        NamePlateCastBar.maxValue = CastDuration
        NamePlateCastBar.CastBarText:SetText(name or channelName)
        NamePlateCastBar:Show()
    else
        NamePlateCastBar:Hide()
    end
end


-- UPDATE HEALTHBAR COLOR

local function UpdateNamePlateHealthBar(Nameplate, unitID)
    if not Nameplate or not unitID then return end
    
    local NameplateHealthbar = Nameplate.UnitFrame.healthBar
    
    if not NameplateHealthbar.originalColor then
        local r, g, b = NameplateHealthbar:GetStatusBarColor()
        NameplateHealthbar.originalColor = {r, g, b}
    end

    local UnitThreat = UnitThreatSituation("player", unitID)
    local UnitTapState = UnitIsTapDenied(unitID)
    
    if UnitThreat and UnitThreat >= 2 then
        NameplateHealthbar:SetStatusBarColor(unpack(ORANGE))
    elseif UnitTapState then
        NameplateHealthbar:SetStatusBarColor(unpack(GREY))
    elseif UnitCanAttack("player", unitID) then
        if UnitReaction(unitID, "player") <= 3 then
            NameplateHealthbar:SetStatusBarColor(unpack(RED))
        else
            NameplateHealthbar:SetStatusBarColor(unpack(YELLOW))
        end
    else
        NameplateHealthbar:SetStatusBarColor(unpack(GREEN))
    end
end


-- UPDATE NAMEPLATE APPEARANCE

local function NameplateUpdate(Nameplate, unitID)
    local UnitNameplate = Nameplate and Nameplate.UnitFrame
    if not UnitNameplate then return end

    local NameplateHealthbar = UnitNameplate.healthBar

    NameplateHealthbar:SetStatusBarTexture(BAR)
    
    NameplateHealthbar.border:Hide()
    UnitNameplate.LevelFrame:Hide()

    if not NameplateHealthbar.backdrop then
        NameplateHealthbar.backdrop = CreateBackdrop(NameplateHealthbar)
    end

    NameplateHealthbar:ClearAllPoints()
    NameplateHealthbar:SetPoint("CENTER", UnitNameplate, "CENTER", 0, 8)
    NameplateHealthbar:SetWidth(UnitNameplate:GetWidth())

    UnitNameplate.name:ClearAllPoints()
    UnitNameplate.name:SetPoint("BOTTOM", NameplateHealthbar, "TOP", 0, 8)
    UnitNameplate.name:SetFont(FONT, MEDIUM, "OUTLINE")
    
    UnitNameplate.name:SetTextColor(unpack(WHITE))
    
    UpdateNamePlateHealthBar(Nameplate, unitID)
    
    if not Nameplate.NamePlateCastBar then
        Nameplate.NamePlateCastBar = NameplateCastbarSetup(Nameplate)
        Nameplate.NamePlateCastBar:SetScript("OnUpdate", OnUpdate)
    end
    
    UpdateNamePlateCastBar(Nameplate.NamePlateCastBar, unitID)
end


-- HANDLE NAMEPLATE SHOW EVENT

local function NameplateOnShow(Nameplate)
    local unitID = Nameplate.unit
    if unitID then
        NameplateUpdate(Nameplate, unitID)
    end
end


-- REGISTER NAMEPLATE EVENTS

local NameplateEvents = CreateFrame("Frame")
NameplateEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateEvents:SetScript("OnEvent", function(self, event, unitID)
    local Nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if Nameplate then
        NameplateUpdate(Nameplate, unitID)
    end
end)


-- REGISTER THREAT EVENTS

local NamePlateHealthBarEvents = CreateFrame("Frame")
NamePlateHealthBarEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
NamePlateHealthBarEvents:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
NamePlateHealthBarEvents:SetScript("OnEvent", function(self, event, unitID)
    local Nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if Nameplate then
        UpdateNamePlateHealthBar(Nameplate, unitID)
    end
end)


-- REGISTER CASTBAR EVENTS

local NameplateCastbarEvents = CreateFrame("Frame")
NameplateCastbarEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_START")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_STOP")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
NameplateCastbarEvents:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
NameplateCastbarEvents:SetScript("OnEvent", function(self, event, unitID)
    local Nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if Nameplate then
        if not Nameplate.NamePlateCastBar then
            Nameplate.NamePlateCastBar = NameplateCastbarSetup(Nameplate)
            Nameplate.NamePlateCastBar:SetScript("OnUpdate", OnUpdate)
        end
        UpdateNamePlateCastBar(Nameplate.NamePlateCastBar, unitID)
    end
end)


-- UPDATE NAMEPLATE CONFIG

local function NameplateConfigUpdate()
    SetCVar("nameplateMinScale", 0.8)
    
    SetCVar("nameplateSelectedScale", 1)
    SetCVar("nameplateMaxScale", 1)
    
    SetCVar("nameplateOverlapH", 1)
    SetCVar("nameplateOverlapV", 1)
    
    SetCVar("nameplateMaxDistance", 40)
end

local NameplateConfigEvents = CreateFrame("Frame")
NameplateConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
NameplateConfigEvents:SetScript("OnEvent", NameplateConfigUpdate)