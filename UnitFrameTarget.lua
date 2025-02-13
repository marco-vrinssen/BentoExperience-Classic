local TargetFrameBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetFrameBackdrop:SetPoint("BOTTOM", UIParent, "BOTTOM", 190, 224)
TargetFrameBackdrop:SetSize(124, 48)
TargetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetFrameBackdrop:SetFrameStrata("HIGH")

TargetFrameBackdrop:SetAttribute("unit", "target")
TargetFrameBackdrop:RegisterForClicks("AnyUp")
TargetFrameBackdrop:SetAttribute("type1", "target")
TargetFrameBackdrop:SetAttribute("type2", "togglemenu")




local TargetPortraitBackdrop = CreateFrame("Button", nil, TargetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
TargetPortraitBackdrop:SetPoint("LEFT", TargetFrameBackdrop, "RIGHT", 0, 0)
TargetPortraitBackdrop:SetSize(48 ,48)
TargetPortraitBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetPortraitBackdrop:SetFrameStrata("HIGH")

TargetPortraitBackdrop:SetAttribute("unit", "target")
TargetPortraitBackdrop:RegisterForClicks("AnyUp")
TargetPortraitBackdrop:SetAttribute("type1", "target")
TargetPortraitBackdrop:SetAttribute("type2", "togglemenu")




local function TargetFrameUpdate()
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

    TargetFrameNameBackground:Hide()
    TargetFrameTextureFrameTexture:Hide()
    
    TargetFrameTextureFramePVPIcon:SetAlpha(0)

    TargetFrameTextureFrameRaidTargetIcon:SetPoint("TOP", TargetPortraitBackdrop, "TOP", 0, -4)
    TargetFrameTextureFrameRaidTargetIcon:SetSize(16, 16)

    TargetFrameTextureFrameDeadText:Hide()

    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("TOP", TargetFrameBackdrop, "TOP", 0, -6)
    TargetFrameTextureFrameName:SetFont(STANDARD_TEXT_FONT, 12)

    if UnitExists("target") then
        if UnitIsPlayer("target") then
            if UnitIsEnemy("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(1, 0.25, 0)
            elseif UnitIsFriend("player", "target") or UnitReaction("player", "target") >= 4 then
                TargetFrameTextureFrameName:SetTextColor(1, 1, 1)
            end
        else
            if UnitIsEnemy("player", "target") and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(1, 0.25, 0)
            elseif UnitReaction("player", "target") == 4 and UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(1, 0.8, 0)
            elseif UnitReaction("player", "target") >= 4 and not UnitCanAttack("player", "target") then
                TargetFrameTextureFrameName:SetTextColor(1, 1, 1)
            end
        end
    end

    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetSize(TargetFrameBackground:GetWidth(), 16)
    TargetFrameHealthBar:SetPoint("BOTTOM", TargetFrameManaBar, "TOP", 0, 0)
    TargetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetSize(TargetFrameBackground:GetWidth(), 8)
    TargetFrameManaBar:SetPoint("BOTTOM", TargetFrameBackdrop, "BOTTOM", 0, 4)
    TargetFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
end

local TargetFrameEvents = CreateFrame("Frame")
TargetFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameEvents:SetScript("OnEvent", TargetFrameUpdate)




local TargetHealthText = TargetFrameHealthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
TargetHealthText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
TargetHealthText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetHealthText:SetTextColor(1, 1, 1, 1)
TargetHealthText:SetShadowOffset(0, 0)

local function TargetHealthUpdate()
    if UnitExists("target") then
        local TargetHealth = UnitHealth("target")
        local TargetMaxHealth = UnitHealthMax("target")
        TargetHealthText:SetText(TargetHealth .. " / " .. TargetMaxHealth)
    else
        TargetHealthText:SetText("")
    end
end

local TargetHealthEvents = CreateFrame("Frame")
TargetHealthEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetHealthEvents:RegisterEvent("UNIT_HEALTH")
TargetHealthEvents:RegisterEvent("UNIT_HEALTH_FREQUENT")
TargetHealthEvents:RegisterEvent("UNIT_MAXHEALTH")
TargetHealthEvents:SetScript("OnEvent", TargetHealthUpdate)




local function TargetPortraitUpdate()
    TargetFramePortrait:ClearAllPoints()
    TargetFramePortrait:SetPoint("CENTER", TargetPortraitBackdrop, "CENTER", 0, 0)
    TargetFramePortrait:SetSize(TargetPortraitBackdrop:GetHeight() - 6, TargetPortraitBackdrop:GetHeight() - 6)
end

local TargetPortraitEvents = CreateFrame("Frame")
TargetPortraitEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetPortraitEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetPortraitEvents:SetScript("OnEvent", TargetPortraitUpdate)

hooksecurefunc("TargetFrame_Update", TargetPortraitUpdate)
hooksecurefunc("UnitFramePortrait_Update", TargetPortraitUpdate)




local function PortraitTextureUpdate(TargetPortrait)
    if TargetPortrait.unit == "target" and TargetPortrait.portrait then
        if UnitIsPlayer(TargetPortrait.unit) then
            local PortraitTexture = CLASS_ICON_TCOORDS[select(2, UnitClass(TargetPortrait.unit))]
            if PortraitTexture then
                TargetPortrait.portrait:SetTexture("Interface/GLUES/CHARACTERCREATE/UI-CHARACTERCREATE-CLASSES")
                local Left, Right, Top, Bottom = unpack(PortraitTexture)
                local LeftUpdate = Left + (Right - Left) * 0.15
                local RightUpdate = Right - (Right - Left) * 0.15
                local TopUpdate = Top + (Bottom - Top) * 0.15
                local BottomUpdate = Bottom - (Bottom - Top) * 0.15
                TargetPortrait.portrait:SetTexCoord(LeftUpdate, RightUpdate, TopUpdate, BottomUpdate)
                TargetPortrait.portrait:SetDrawLayer("BACKGROUND", -1)
            end
        else
            TargetPortrait.portrait:SetTexCoord(0.15, 0.85, 0.15, 0.85)
        end
    end
end

hooksecurefunc("UnitFramePortrait_Update", PortraitTextureUpdate)




local function TargetGroupUpdate()
    TargetFrameTextureFrameLeaderIcon:ClearAllPoints()
    TargetFrameTextureFrameLeaderIcon:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 0)
end

local TargetGroupEvents = CreateFrame("Frame")
TargetGroupEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetGroupEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetGroupEvents:SetScript("OnEvent", TargetGroupUpdate)

hooksecurefunc("TargetFrame_Update", TargetGroupUpdate)




local function TragetLevelUpdate()
    TargetFrameTextureFrameLevelText:ClearAllPoints()
    TargetFrameTextureFrameLevelText:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -4)
    TargetFrameTextureFrameLevelText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")

    if not UnitCanAttack("player", "target") or not UnitCanAttack("target", "player") then
        TargetFrameTextureFrameLevelText:SetTextColor(1, 1, 1)
    end

    TargetFrameTextureFrameHighLevelTexture:ClearAllPoints()
    TargetFrameTextureFrameHighLevelTexture:SetPoint("TOP", TargetPortraitBackdrop, "BOTTOM", 0, -6)
    TargetFrameTextureFrameHighLevelTexture:SetTexture("Interface/TargetingFrame/UI-RaidTargetingIcon_8")
end

local TargetLevelEvents = CreateFrame("Frame")
TargetLevelEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetLevelEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetLevelEvents:SetScript("OnEvent", TragetLevelUpdate)

hooksecurefunc("TargetFrame_Update", TragetLevelUpdate)




local ToTFrameBackdrop = CreateFrame("Button", nil, TargetFrameToT, "SecureUnitButtonTemplate, BackdropTemplate")
ToTFrameBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
ToTFrameBackdrop:SetSize(64, 24)
ToTFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12})
ToTFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
ToTFrameBackdrop:SetFrameStrata("HIGH")

ToTFrameBackdrop:SetAttribute("unit", "targettarget")
ToTFrameBackdrop:RegisterForClicks("AnyUp")
ToTFrameBackdrop:SetAttribute("type1", "target")
ToTFrameBackdrop:SetAttribute("type2", "togglemenu")

local function ToTFrameUpdate()
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint("CENTER", TargetFrameBackdrop, "CENTER", 0, 0)

    TargetFrameToTTextureFrame:Hide()
    TargetFrameToTTextureFrameName:SetParent(TargetFrameToT)
    TargetFrameToTTextureFrameName:ClearAllPoints()
    TargetFrameToTTextureFrameName:SetPoint("BOTTOMLEFT", ToTFrameBackdrop, "TOPLEFT", 2, 2)
    TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1, 1)

    TargetFrameToTHealthBar:ClearAllPoints()
    TargetFrameToTHealthBar:SetPoint("BOTTOM", TargetFrameToTManaBar, "TOP", 0, 0)
    TargetFrameToTHealthBar:SetPoint("TOP", ToTFrameBackdrop, "TOP", 0, -2)
    TargetFrameToTHealthBar:SetWidth(ToTFrameBackdrop:GetWidth()-4)
    TargetFrameToTHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameToTManaBar:ClearAllPoints()
    TargetFrameToTManaBar:SetPoint("BOTTOM", ToTFrameBackdrop, "BOTTOM", 0, 2)
    TargetFrameToTManaBar:SetHeight(8)
    TargetFrameToTManaBar:SetWidth(ToTFrameBackdrop:GetWidth()-4)
    TargetFrameToTManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameToTBackground:Hide()

    TargetFrameToTTextureFrameTexture:Hide()
    TargetFrameToTPortrait:Hide()

    for i = 1, MAX_TARGET_BUFFS do
        local ToTBuff = _G["TargetFrameToTBuff" .. i]
        if ToTBuff then
            ToTBuff:SetAlpha(0)
        end
    end

    for i = 1, MAX_TARGET_DEBUFFS do
        local ToTDebuff = _G["TargetFrameToTDebuff" .. i]
        if ToTDebuff then
            ToTDebuff:SetAlpha(0)
        end
    end
end

local ToTFrameEvents = CreateFrame("Frame")
ToTFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
ToTFrameEvents:SetScript("OnEvent", ToTFrameUpdate)




local function TargetAurasUpdate()
    local InitialBuff = _G["TargetFrameBuff1"]
    if InitialBuff then
        InitialBuff:ClearAllPoints()
        InitialBuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 2, 2)
    end

    local InitialDebuff = _G["TargetFrameDebuff1"]
    if InitialDebuff then
        InitialDebuff:ClearAllPoints()
        if InitialBuff then
            InitialDebuff:SetPoint("BOTTOMLEFT", InitialBuff, "TOPLEFT", 0, 2)
        else
            InitialDebuff:SetPoint("BOTTOMLEFT", TargetFrameBackdrop, "TOPLEFT", 2, 2)
        end
    end
end

hooksecurefunc("TargetFrame_Update", TargetAurasUpdate)
hooksecurefunc("TargetFrame_UpdateAuras", TargetAurasUpdate)

local TargetAurasEvents = CreateFrame("Frame")
TargetAurasEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetAurasEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetAurasEvents:SetScript("OnEvent", TargetAurasUpdate)




local TargetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
TargetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
TargetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
TargetSpellBarBackdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12 })
TargetSpellBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
TargetSpellBarBackdrop:SetFrameStrata("HIGH")

local function TargetSpellBarUpdate()
    TargetFrameSpellBar:ClearAllPoints()
    TargetFrameSpellBar:SetPoint("TOPLEFT", TargetSpellBarBackdrop, "TOPLEFT", 3, -2)
    TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", TargetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
    TargetFrameSpellBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

    TargetFrameSpellBar.Border:SetTexture(nil)
    TargetFrameSpellBar.Flash:SetTexture(nil)
    TargetFrameSpellBar.Spark:SetTexture(nil)

    TargetFrameSpellBar.Icon:SetSize(TargetSpellBarBackdrop:GetHeight() - 4, TargetSpellBarBackdrop:GetHeight() - 4)

    TargetFrameSpellBar.Text:ClearAllPoints()
    TargetFrameSpellBar.Text:SetPoint("CENTER", TargetSpellBarBackdrop, "CENTER", 0, 0)
    TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 10)
end

TargetFrameSpellBar:HookScript("OnShow", TargetSpellBarUpdate)
TargetFrameSpellBar:HookScript("OnUpdate", TargetSpellBarUpdate)

local TargetSpellBarEvents = CreateFrame("Frame")
TargetSpellBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetSpellBarEvents:SetScript("OnEvent", TargetSpellBarUpdate)




local TargetClassificationText = TargetFrame:CreateFontString(nil, "OVERLAY")
TargetClassificationText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetClassificationText:SetPoint("BOTTOM", TargetPortraitBackdrop, "TOP", 0, 4)

local function TargetClassificationUpdate()
    local TargetClassification = UnitClassification("target")
    if TargetClassification == "worldboss" then
        TargetClassificationText:SetText("Boss")
        TargetClassificationText:SetTextColor(1, 0.25, 0)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.25, 0)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.25, 0)
    elseif TargetClassification == "elite" then
        TargetClassificationText:SetText("Elite")
        TargetClassificationText:SetTextColor(1, 0.8, 0)
        TargetFrameBackdrop:SetBackdropBorderColor(1, 0.8, 0)
        TargetPortraitBackdrop:SetBackdropBorderColor(1, 0.8, 0)
    elseif TargetClassification == "rare" then
        TargetClassificationText:SetText("Rare")
        TargetClassificationText:SetTextColor(0.8, 0.8, 0.8)
        TargetFrameBackdrop:SetBackdropBorderColor(0.8, 0.8, 0.8)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.8, 0.8, 0.8)
    else
        TargetClassificationText:SetText("")
        TargetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
        TargetPortraitBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
    end
end

hooksecurefunc("TargetFrame_Update", TargetClassificationUpdate)

local TargetClassificationEvents = CreateFrame("Frame")
TargetClassificationEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetClassificationEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetClassificationEvents:SetScript("OnEvent", TargetClassificationUpdate)




local TargetThreatText = TargetThreatText or TargetFrame:CreateFontString(nil, "OVERLAY")
TargetThreatText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
TargetThreatText:SetPoint("BOTTOM", TargetClassificationText, "TOP", 0, 4)

local function TargetThreatUpdate()
    if not UnitExists("target") or UnitIsDead("target") or not UnitCanAttack("player", "target") then
        TargetThreatText:Hide()
        return
    end

    local ThreatTanking, ThreatStatus, ThreatPercentage = UnitDetailedThreatSituation("player", "target")
    if ThreatPercentage then
        TargetThreatText:SetText(string.format("%.0f%%", ThreatPercentage))
        TargetThreatText:Show()
        if ThreatTanking or (ThreatStatus and ThreatStatus >= 2) then
            TargetThreatText:SetTextColor(1, 0.25, 0)
        elseif ThreatStatus == 1 then
            TargetThreatText:SetTextColor(1, 0.8, 0)
        else
            TargetThreatText:SetTextColor(0.5, 0.5, 0.5)
        end
    else
        TargetThreatText:Hide()
    end
end

TargetFrame:HookScript("OnShow", TargetThreatUpdate)
TargetFrame:HookScript("OnEvent", TargetThreatUpdate)
TargetFrame:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE")
TargetFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
TargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")




local function TargetConfigUpdate()
    SetCVar("showTargetCastbar", 1)
    TARGET_FRAME_BUFFS_ON_TOP = true
end

local TargetConfigEvents = CreateFrame("Frame")
TargetConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetConfigEvents:SetScript("OnEvent", TargetConfigUpdate)