-- UPDATE ACTION BARS

local function ActionBarUpdate()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 88)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:Show()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 134)
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    MultiBarBottomRight:Show()
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 24)
    MultiBarBottomRight:SetMovable(true)
    MultiBarBottomRight:SetUserPlaced(true)
    MultiBarBottomRight:SetScale(0.8)

    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -16, 0)
    MultiBarRight:SetMovable(true)
    MultiBarRight:SetUserPlaced(true)

    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetPoint("RIGHT", MultiBarRight, "LEFT", -2, 0)
    MultiBarLeft:SetMovable(true)
    MultiBarLeft:SetUserPlaced(true)

    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    MainMenuBarPageNumber:Hide()
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
    MainMenuMaxLevelBar0:Hide()
    MainMenuMaxLevelBar1:Hide()
    MainMenuMaxLevelBar2:Hide()
    MainMenuMaxLevelBar3:Hide()
    MainMenuBarMaxLevelBar:Hide()
    MainMenuBarOverlayFrame:Hide()
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture0.Show = SlidingActionBarTexture0.Hide
    SlidingActionBarTexture1:Hide()
    SlidingActionBarTexture1.Show = SlidingActionBarTexture1.Hide
    MainMenuBarPerformanceBarFrame:Hide()
    MainMenuBarPerformanceBar:Hide()
end

local ActionBarEvents = CreateFrame("Frame")
ActionBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBarEvents:SetScript("OnEvent", ActionBarUpdate)




-- UPDATE ACTION BUTTONS

local function UpdateActionButtonAppearance()
    local function hideNormalTexture(button)
        if button then
            local normalTexture = _G[button:GetName() .. "NormalTexture"]
            if normalTexture then
                normalTexture:SetAlpha(0)
                normalTexture:SetTexture(nil)
            end
            local floatingBG = _G[button:GetName() .. "FloatingBG"]
            if floatingBG then
                floatingBG:SetAlpha(0)
                floatingBG:SetTexture(nil)
            end
        end
    end

    local function customizeButton(button)
        if button then
            if not button.customBorder then
                local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
                backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
                backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
                backdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12 })
                backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                backdrop:SetFrameStrata("HIGH")
                button.customBorder = backdrop
            end

            local icon = _G[button:GetName() .. "Icon"]
            if icon then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end
    end

    local function updateButtonFonts(button)
        if button then
            local macroName = _G[button:GetName() .. "Name"]
            if macroName then
                macroName:SetFont(macroName:GetFont(), 10)
                macroName:SetTextColor(1, 1, 1, 0.75)
            end
            local hotkey = _G[button:GetName() .. "HotKey"]
            if hotkey then
                hotkey:SetFont(hotkey:GetFont(), 12, "OUTLINE")
                hotkey:SetTextColor(1, 1, 1, 1)
            end
            local cooldown = _G[button:GetName() .. "Cooldown"]
            if cooldown then
                local cooldownText = cooldown:GetRegions()
                if cooldownText and cooldownText:GetObjectType() == "FontString" then
                    cooldownText:SetFont(cooldownText:GetFont(), 20, "OUTLINE")
                    cooldownText:SetTextColor(1, 1, 1, 1)
                end
            end
        end
    end

    for i = 1, 12 do
        local buttons = {
            _G["ActionButton" .. i],
            _G["MultiBarBottomLeftButton" .. i],
            _G["MultiBarBottomRightButton" .. i],
            _G["MultiBarRightButton" .. i],
            _G["MultiBarLeftButton" .. i]
        }
        for _, button in ipairs(buttons) do
            hideNormalTexture(button)
            customizeButton(button)
            updateButtonFonts(button)
        end
    end
end

local ButtonAppearanceEvents = CreateFrame("Frame")
ButtonAppearanceEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ButtonAppearanceEvents:SetScript("OnEvent", UpdateActionButtonAppearance)




-- UPDATE CLASS ACTION BAR

local function ClassBarUpdate()
    if InCombatLockdown() then return end
    local PreviousClassButton
    local anchorButton = MultiBarBottomLeftButton1:IsShown() and MultiBarBottomLeftButton1 or ActionButton1

    for numStances = 1, NUM_STANCE_SLOTS do
        local ClassButton = _G["StanceButton" .. numStances]
        
        ClassButton:ClearAllPoints()

        if not PreviousClassButton then
            ClassButton:SetPoint("BOTTOMLEFT", anchorButton, "TOPLEFT", 0, 8)
        else
            ClassButton:SetPoint("LEFT", PreviousClassButton, "RIGHT", 4, 0)
        end

        for numTextures = 1, 3 do
            local NormalTexture = _G["StanceButton" .. numStances .. "NormalTexture" .. numTextures]
            if NormalTexture then
                NormalTexture:SetAlpha(0)
                NormalTexture:SetTexture(nil)
            end
        end

        PreviousClassButton = ClassButton
    end

    StanceBarLeft:SetAlpha(0)
    StanceBarLeft:SetTexture(nil)
    StanceBarMiddle:SetAlpha(0)
    StanceBarMiddle:SetTexture(nil)
    StanceBarRight:SetAlpha(0)
    StanceBarRight:SetTexture(nil)
end

local ClassBarEvents = CreateFrame("Frame")
ClassBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassBarEvents:RegisterEvent("UPDATE_STEALTH")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
ClassBarEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
ClassBarEvents:SetScript("OnEvent", ClassBarUpdate)




-- UPDATE PET ACTION BAR

local function HidePetButtonTextures(button)
    local normalTexture = _G[button:GetName() .. "NormalTexture"]
    if normalTexture then
        normalTexture:SetAlpha(0)
        normalTexture:SetTexture(nil)
    end
    local normalTexture2 = _G[button:GetName() .. "NormalTexture2"]
    if normalTexture2 then
        normalTexture2:SetAlpha(0)
        normalTexture2:SetTexture(nil)
    end
end

local function PetBarUpdate()
    local PreviousPetButton

    for numStances = 1, 10 do
        local PetButton = _G["PetActionButton" .. numStances]
        PetButton:ClearAllPoints()

        if not PreviousPetButton then
            PetButton:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", -2, 8)
        else
            PetButton:SetPoint("LEFT", PreviousPetButton, "RIGHT", 4, 0)
        end

        PetButton:SetScale(0.8)
        PetButton:SetAlpha(0.5)
        PetButton:Show()

        HidePetButtonTextures(PetButton)

        PreviousPetButton = PetButton
    end
end

local PetBarEvents = CreateFrame("Frame")
PetBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PetBarEvents:RegisterEvent("UNIT_PET")
PetBarEvents:RegisterEvent("PET_BAR_UPDATE")
PetBarEvents:SetScript("OnEvent", PetBarUpdate)




-- UPDATE VEHICLE LEAVE BUTTON

local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(36, 36)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", PlayerPortrait, "TOPLEFT", -4, 4)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)