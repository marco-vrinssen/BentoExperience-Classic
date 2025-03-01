-- UPDATE AND REPOSITION ACTION BARS

local function UpdateActionButtons()
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
    MainMenuBarPerformanceBarFrame.Show = MainMenuBarPerformanceBarFrame.Hide
end

local ActionBarFrame = CreateFrame("Frame")
ActionBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBarFrame:SetScript("OnEvent", UpdateActionButtons)


-- UPDATE BUTTON USABILITY

local function UpdateButtonUsability(self)
    if not self or not self.action then 
        return 
    end

    local isUsable = IsUsableAction(self.action)
    local inRange = IsActionInRange(self.action)

    local color = (not isUsable or inRange == false) and RED or WHITE
    self.icon:SetVertexColor(unpack(color))
end

hooksecurefunc("ActionButton_OnUpdate", UpdateButtonUsability)


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
                backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
                backdrop:SetBackdropBorderColor(unpack(GREY))
                backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
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
                macroName:SetFont(FONT, SMALL, "OUTLINE")
                macroName:SetTextColor(unpack(WHITE))
                macroName:SetAlpha(0.5)
            end
            local hotkey = _G[button:GetName() .. "HotKey"]
            if hotkey then
                hotkey:SetFont(FONT, MEDIUM, "OUTLINE")
                hotkey:SetTextColor(unpack(WHITE))
                hotkey:SetAlpha(0.75)
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

local ActionButtonFrame = CreateFrame("Frame")
ActionButtonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionButtonFrame:SetScript("OnEvent", UpdateActionButtonAppearance)


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
        backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
        backdrop:SetBackdropBorderColor(unpack(GREY))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
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


-- UPDATE PET BUTTONS

local function HidePetButtonTextures(button)
    local PetButtonTexture1 = _G[button:GetName() .. "NormalTexture"]
    if PetButtonTexture1 then
        PetButtonTexture1:SetAlpha(0)
        PetButtonTexture1:SetTexture(nil)
    end
    
    local PetButtonTexture2 = _G[button:GetName() .. "NormalTexture2"]
    if PetButtonTexture2 then
        PetButtonTexture2:SetAlpha(0)
        PetButtonTexture2:SetTexture(nil)
    end
    
    local AutoCastable = _G[button:GetName() .. "AutoCastable"]
    if AutoCastable then
        AutoCastable:SetAlpha(0)
        AutoCastable:Hide()
    end
end

local function AddCustomBorderToPetButton(button)
    if not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM })
        backdrop:SetBackdropBorderColor(unpack(GREY))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
    end
    
    local icon = _G[button:GetName() .. "Icon"]
    if icon then
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end
end

local function UpdatePetButton()
    local PreviousPetButton

    for NumStances = 1, 10 do
        local PetButton = _G["PetActionButton" .. NumStances]
        PetButton:ClearAllPoints()

        if not PreviousPetButton then
            PetButton:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, 6)
        else
            PetButton:SetPoint("LEFT", PreviousPetButton, "RIGHT", 6, 0)
        end

        PetButton:SetScale(0.9)

        HidePetButtonTextures(PetButton)
        AddCustomBorderToPetButton(PetButton)

        PreviousPetButton = PetButton
    end
end

local PetButtonsFrame = CreateFrame("Frame")
PetButtonsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PetButtonsFrame:RegisterEvent("UNIT_PET")
PetButtonsFrame:RegisterEvent("PET_BAR_UPDATE")
PetButtonsFrame:SetScript("OnEvent", UpdatePetButton)


-- UPDATE VEHICLE LEAVE BUTTON

local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(24, 24)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", PlayerPortrait, "TOPLEFT", -2, 2)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)