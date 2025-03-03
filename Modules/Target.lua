-- CREATE TARGET BACKDROPS

TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 240)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetFrameBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")

TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48, 48)
TargetPortraitBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
TargetPortraitBackdrop:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE TARGET FRAME

local function updateTargetFrame()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "BOTTOMLEFT", 0, 0)
    TargetFrame:SetPoint("TOPRIGHT", TargetPortraitBackdrop, "TOPRIGHT", 0, 0)
    TargetFrame:SetAttribute("unit", "target")
    TargetFrame:RegisterForClicks("AnyUp")
    TargetFrame:SetAttribute("type1", "target")
    TargetFrame:SetAttribute("type2", "togglemenu")

    TargetFrameBackground:ClearAllPoints()
    TargetFrameBackground:SetPoint("TOPLEFT", TargetFrameBackdrop, "TOPLEFT", 3, -3)
    TargetFrameBackground:SetPoint("BOTTOMRIGHT", TargetFrameBackdrop, "BOTTOMRIGHT", -3, 3)

    TargetFrameTextureFrameTexture:Hide()
    TargetFrameTextureFramePVPIcon:SetAlpha(0)

    TargetFrameTextureFrameDeadText:Hide()

    TargetFrameNameBackground:Hide()
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -7)
    TargetFrameTextureFrameName:SetFont(FONT, MEDIUM, "OUTLINE")
    
    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(FONT, MEDIUM, "OUTLINE")
    TargetFrameTextureFrameLevelText:SetTextColor(unpack(WHITE))

    TargetFrameTextureFrameHighLevelTexture:Hide()

    if UnitExists("target") then
        if UnitIsPlayer("target") then
            if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for enemy players that can be attacked
            else
                TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral or friendly players
            end
        else
            if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(RED)) -- Red for hostile NPCs
            elseif UnitReaction("player", "target") == 4 and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(unpack(YELLOW)) -- Yellow for neutral but attackable NPCs
            else
                TargetFrameTextureFrameName:SetTextColor(unpack(WHITE)) -- White for neutral non-attackable or friendly NPCs
            end
        end
    end
end

local targetEvents = CreateFrame("Frame")
targetEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetEvents:SetScript("OnEvent", updateTargetFrame)


-- UPDATE TARGET RESOURCES

local function updateTargetResources()
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 16)
    TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)
    TargetFrameHealthBar:SetStatusBarTexture(BAR)
    TargetFrameHealthBar:SetStatusBarColor(unpack(GREEN))

    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
    TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 3)
    TargetFrameManaBar:SetStatusBarTexture(BAR)
    
    local powerType = UnitPowerType("target")
    
    if powerType == 0 then -- Mana
        TargetFrameManaBar:SetStatusBarColor(unpack(BLUE))
    elseif powerType == 1 then -- Rage
        TargetFrameManaBar:SetStatusBarColor(unpack(RED))
    elseif powerType == 3 then -- Energy
        TargetFrameManaBar:SetStatusBarColor(unpack(YELLOW))
    end
end

local targetResourceEvents = CreateFrame("Frame")
targetResourceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetResourceEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetResourceEvents:RegisterEvent("UNIT_HEALTH")
targetResourceEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
targetResourceEvents:RegisterEvent("UNIT_MAXHEALTH")
targetResourceEvents:RegisterEvent("UNIT_POWER_UPDATE")
targetResourceEvents:RegisterEvent("UNIT_MAXPOWER")
targetResourceEvents:RegisterEvent("UNIT_DISPLAYPOWER")
targetResourceEvents:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" then
        updateTargetResources()
    elseif unit == "target" then
        updateTargetResources()
    end
end)


-- UPDATE TARGET PORTRAIT

local function targetPortraitUpdate()
    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local targetPortraitEvents = CreateFrame("Frame")
targetPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetPortraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetPortraitEvents:SetScript("OnEvent", targetPortraitUpdate)

hooksecurefunc("TargetFrame_Update", targetPortraitUpdate)
hooksecurefunc("UnitFramePortrait_Update", targetPortraitUpdate)

local function portraitTextureUpdate(targetPortrait)
    if targetPortrait.unit == "target" and targetPortrait.portrait then
        if UnitIsPlayer(targetPortrait.unit) then
            local portraitTexture = CLASS_ICON_TCOORDS[select(2, UnitClass(targetPortrait.unit))]
            if portraitTexture then
                targetPortrait.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
                local left, right, top, bottom = unpack(portraitTexture)
                local leftUpdate = left + (right - left) * 0.15
                local rightUpdate = right - (right - left) * 0.15
                local topUpdate = top + (bottom - top) * 0.15
                local bottomUpdate = bottom - (bottom - top) * 0.15
                targetPortrait.portrait:SetTexCoord(leftUpdate, rightUpdate, topUpdate, bottomUpdate)
                targetPortrait.portrait:SetDrawLayer("BACKGROUND", -1)
            end
        else
            targetPortrait.portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end
    end
end

hooksecurefunc("UnitFramePortrait_Update", portraitTextureUpdate)


-- UPDATE TARGET AURAS

local function updateTargetAuras()
    local buff, buffIndex, debuff, debuffIndex = 1, 1, 1, 1
    local buffColumns, debuffColumns = 5, 5
    local auraSize = 20
    local xOffset, yOffset = 4, 4
    local horizontalStartOffset = 4
    local verticalStartOffset = 4  -- Add vertical offset to move auras up by 4px

    local currentBuff = _G["TargetFrameBuff"..buffIndex]
    while currentBuff do
        local row = ceil(buffIndex / buffColumns) - 1
        local col = (buffIndex - 1) % buffColumns
        
        currentBuff:ClearAllPoints()
        currentBuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + row * (auraSize + yOffset))
        
        currentBuff:SetSize(auraSize, auraSize)
        
        if not currentBuff.backdrop then
            currentBuff.backdrop = CreateFrame("Frame", nil, currentBuff, "BackdropTemplate")
            currentBuff.backdrop:SetPoint("TOPLEFT", currentBuff, "TOPLEFT", -2, 2)
            currentBuff.backdrop:SetPoint("BOTTOMRIGHT", currentBuff, "BOTTOMRIGHT", 2, -2)
            currentBuff.backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = 8 })
            currentBuff.backdrop:SetBackdropBorderColor(unpack(GREY))
            currentBuff.backdrop:SetFrameLevel(currentBuff:GetFrameLevel() + 2)
        end
        
        local icon = _G[currentBuff:GetName().."Icon"]
        if icon then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
        
        buffIndex = buffIndex + 1
        currentBuff = _G["TargetFrameBuff"..buffIndex]
    end
    
    local currentDebuff = _G["TargetFrameDebuff"..debuffIndex]
    while currentDebuff do
        local row = ceil(debuffIndex / debuffColumns) - 1
        local col = (debuffIndex - 1) % debuffColumns
        
        local buffRows = ceil((buffIndex - 1) / buffColumns)
        local verticalOffset = buffRows * (auraSize + yOffset) + yOffset
        
        currentDebuff:ClearAllPoints()
        currentDebuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 
            horizontalStartOffset + col * (auraSize + xOffset), 
            verticalStartOffset + verticalOffset + row * (auraSize + yOffset))
        
        currentDebuff:SetSize(auraSize, auraSize)
        
        if not currentDebuff.backdrop then
            currentDebuff.backdrop = CreateFrame("Frame", nil, currentDebuff, "BackdropTemplate")
            currentDebuff.backdrop:SetPoint("TOPLEFT", currentDebuff, "TOPLEFT", -2, 2)
            currentDebuff.backdrop:SetPoint("BOTTOMRIGHT", currentDebuff, "BOTTOMRIGHT", 2, -2)
            currentDebuff.backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = 8 })
            currentDebuff.backdrop:SetBackdropBorderColor(unpack(RED))
            currentDebuff.backdrop:SetFrameLevel(currentDebuff:GetFrameLevel() + 2)
        end
        
        local icon = _G[currentDebuff:GetName().."Icon"]
        if icon then
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end

        currentDebuff.backdrop:SetBackdropBorderColor(unpack(RED))
        
        debuffIndex = debuffIndex + 1
        currentDebuff = _G["TargetFrameDebuff"..debuffIndex]
    end
end

hooksecurefunc("TargetFrame_Update", updateTargetAuras)
hooksecurefunc("TargetFrame_UpdateAuras", updateTargetAuras)

local targetAuraEvents = CreateFrame("Frame")
targetAuraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetAuraEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetAuraEvents:RegisterEvent("UNIT_AURA")
targetAuraEvents:SetScript("OnEvent", function(self, event, unit)
    if unit == "target" or not unit then
        updateTargetAuras()
    end
end)


-- GENERATE AND UPDATE TARGET CLASSIFICATION TEXT

local targetTypeText = TargetFrame:CreateFontString(nil, "OVERLAY")
targetTypeText:SetFont(FONT, MEDIUM, "OUTLINE")
targetTypeText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function targetClassificationUpdate()
    local targetClassification = UnitClassification("target")
    if targetClassification == "worldboss" then
        targetTypeText:SetText("Boss")
        targetTypeText:SetTextColor(unpack(ORANGE))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(ORANGE))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(ORANGE))
    elseif targetClassification == "elite" then
        targetTypeText:SetText("Elite")
        targetTypeText:SetTextColor(unpack(YELLOW))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(YELLOW))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(YELLOW))
    elseif targetClassification == "rare" then
        targetTypeText:SetText("Rare")
        targetTypeText:SetTextColor(unpack(WHITE))
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(WHITE))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(WHITE))
    else
        targetTypeText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
        TargetPortraitBackdrop:SetBackdropBorderColor(unpack(GREY))
    end
end

local targetTypeEvents = CreateFrame("Frame")
targetTypeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetTypeEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetTypeEvents:SetScript("OnEvent", targetClassificationUpdate)


-- CREATE AGGRO TEXT

local targetThreatText = TargetFrame:CreateFontString(nil, "OVERLAY")
targetThreatText:SetFont(FONT, MEDIUM, "OUTLINE")
targetThreatText:SetPoint("BOTTOM", targetTypeText, "TOP", 0, 8)
targetThreatText:Hide()


-- UPDATE AGGRO STATUS

local function updateAggroStatus()
    local isTanking, status, threatPct = UnitDetailedThreatSituation("player", "target")
    if status and threatPct then
        targetThreatText:SetText(string.format("%d%%", threatPct))
        if threatPct == 100 then
            targetThreatText:SetTextColor(unpack(RED))
        else
            targetThreatText:SetTextColor(unpack(YELLOW))
        end
        targetThreatText:Show()
    else
        targetThreatText:Hide()
    end
end

local targetThreatEvents = CreateFrame("Frame")
targetThreatEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetThreatEvents:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
targetThreatEvents:SetScript("OnEvent", updateAggroStatus)

hooksecurefunc("TargetFrame_Update", updateAggroStatus)


-- UPDATE TARGET RAID ICON

local tragetRaidIconBackdrop = CreateFrame("Frame", nil, TargetFrame, "BackdropTemplate")
tragetRaidIconBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "TOPRIGHT", -2, -2)
tragetRaidIconBackdrop:SetSize(28, 28)
tragetRaidIconBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = EDGE, edgeSize = MEDIUM,
    insets = {left = 3, right = 3, top = 3, bottom = 3}
})
tragetRaidIconBackdrop:SetBackdropColor(0, 0, 0, 1)
tragetRaidIconBackdrop:SetBackdropBorderColor(unpack(GREY))
tragetRaidIconBackdrop:Hide()

local function updateTargetRaidIcon()
    if GetRaidTargetIndex("target") then
        tragetRaidIconBackdrop:Show()
        TargetFrameTextureFrameRaidTargetIcon:ClearAllPoints()
        TargetFrameTextureFrameRaidTargetIcon:SetPoint("CENTER", tragetRaidIconBackdrop, "CENTER", 0, 0)
        TargetFrameTextureFrameRaidTargetIcon:SetSize(12, 12)
        -- Check if icon exists before setting frame level
        if TargetFrameTextureFrameRaidTargetIcon and TargetFrameTextureFrameRaidTargetIcon.SetFrameLevel then
            TargetFrameTextureFrameRaidTargetIcon:SetFrameLevel(tragetRaidIconBackdrop:GetFrameLevel() + 2)
        end
    else
        tragetRaidIconBackdrop:Hide()
    end
end

local targetRaidIconEvents = CreateFrame("Frame")
targetRaidIconEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
targetRaidIconEvents:RegisterEvent("RAID_TARGET_UPDATE")
targetRaidIconEvents:SetScript("OnEvent", updateTargetRaidIcon)


-- UPDATE TARGET GROUP INDICATORS

local function targetGroupUpdate()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local targetGroupFrame = CreateFrame("Frame")
targetGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
targetGroupFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
targetGroupFrame:SetScript("OnEvent", targetGroupUpdate)

hooksecurefunc("TargetFrame_Update", targetGroupUpdate)


-- UPDATE TARGET CASTBAR

local targetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
targetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
targetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
targetSpellBarBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
targetSpellBarBackdrop:SetBackdropBorderColor(unpack(GREY))
targetSpellBarBackdrop:SetFrameLevel(TargetFrameSpellBar:GetFrameLevel() + 2)

local function updateTargetCastbar()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", targetSpellBarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", targetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture(BAR)
    TargetFrameSpellBar:SetStatusBarColor(unpack(YELLOW))
    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)
    TargetFrameSpellBar.Icon:SetSize(targetSpellBarBackdrop:GetHeight() - 4, targetSpellBarBackdrop:GetHeight() - 4)
    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", targetSpellBarBackdrop, "CENTER", 0, 0)
    TargetFrameSpellBar.Text:SetFont(FONT, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", updateTargetCastbar)
TargetFrameSpellBar:HookScript("OnUpdate", updateTargetCastbar)

local targetCastBarEvents = CreateFrame("Frame")
targetCastBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetCastBarEvents:SetScript("OnEvent", updateTargetCastbar)


-- UPDATE TARGET CONFIGURATION

local function targetConfigUpdate()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local targetConfigEvents = CreateFrame("Frame")
targetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
targetConfigEvents:SetScript("OnEvent", targetConfigUpdate)