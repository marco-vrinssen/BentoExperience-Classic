-- UPDATE AURA DURATION

local function UpdateAuraTimer(aura)
    local AuraDuration = _G[aura:GetName().."Duration"]
    if AuraDuration then
        AuraDuration:SetFont(FONT, 10, "OUTLINE")
        AuraDuration:SetTextColor(1, 1, 1)
        AuraDuration:ClearAllPoints()
        AuraDuration:SetPoint("BOTTOM", aura, "BOTTOM", 1, -12)
    end
end

hooksecurefunc("AuraButton_UpdateDuration", function(aura)
    if aura then
        UpdateAuraTimer(aura)
    end
end)


-- UPDATE AURA DESIGN

local function StyleAuraButton(button)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
        backdrop:SetBackdropBorderColor(unpack(GREY))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
    end

    local icon = _G[button:GetName().."Icon"]
    if icon then
        icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    end
end

hooksecurefunc("AuraButton_Update", function(buttonName, index, filter)
    local button = _G[buttonName..index]
    if button then
        StyleAuraButton(button)
    end
end)


-- RESPOSITION AURAS

local function UpdateAuraPosition()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 0)
end


-- INITIALIZE AURA UPDATE

local function UpdatePlayerAuras()
    UpdateAuraPosition()
    
    for i = 1, BUFF_MAX_DISPLAY do
        local buff = _G["BuffButton"..i]
        if buff then
            UpdateAuraTimer(buff)
            StyleAuraButton(buff)
        end
    end

    for i = 1, DEBUFF_MAX_DISPLAY do
        local debuff = _G["DebuffButton"..i]
        if debuff then
            UpdateAuraTimer(debuff)
            StyleAuraButton(debuff)
        end
    end
end

local AuraEvents = CreateFrame("Frame")
AuraEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AuraEvents:RegisterEvent("UNIT_AURA")
AuraEvents:SetScript("OnEvent", UpdatePlayerAuras)