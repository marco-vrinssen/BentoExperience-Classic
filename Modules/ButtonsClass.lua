-- UPDATE CLASS BUTTONS

local function HideClassButtonTextures(button)
    for NumTextures = 1, 3 do
        local NormalTexture = _G[button:GetName() .. "NormalTexture" .. NumTextures]
        if NormalTexture then
            NormalTexture:SetAlpha(0)
            NormalTexture:SetTexture(nil)
        end
    end
end

local function AddCustomBorderToClassButton(button)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
        backdrop:SetBackdropBorderColor(unpack(N.RGB))
        backdrop:SetFrameStrata("HIGH")
        button.customBorder = backdrop
    end
    
    local icon = _G[button:GetName() .. "Icon"]
    if icon then
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

local function UpdateClassButtons()
    if InCombatLockdown() then return end
    
    local PreviousClassButton
    local AnchorButton = MultiBarBottomLeftButton1:IsShown() and MultiBarBottomLeftButton1 or ActionButton1

    for NumStances = 1, NUM_STANCE_SLOTS do
        local ClassButton = _G["StanceButton" .. NumStances]
        
        ClassButton:ClearAllPoints()

        if not PreviousClassButton then
            ClassButton:SetPoint("BOTTOMLEFT", AnchorButton, "TOPLEFT", 0, 8)
        else
            ClassButton:SetPoint("LEFT", PreviousClassButton, "RIGHT", 4, 0)
        end

        ClassButton:SetScale(0.9)
        
        HideClassButtonTextures(ClassButton)
        AddCustomBorderToClassButton(ClassButton)

        PreviousClassButton = ClassButton
    end

    StanceBarLeft:SetAlpha(0)
    StanceBarLeft:SetTexture(nil)
    StanceBarMiddle:SetAlpha(0)
    StanceBarMiddle:SetTexture(nil)
    StanceBarRight:SetAlpha(0)
    StanceBarRight:SetTexture(nil)
end

local ClassButtonsFrame = CreateFrame("Frame")
ClassButtonsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassButtonsFrame:RegisterEvent("UPDATE_STEALTH")
ClassButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ClassButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
ClassButtonsFrame:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
ClassButtonsFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
ClassButtonsFrame:SetScript("OnEvent", UpdateClassButtons)