-- Function to update the main action bar and additional bars
local function ActionBarUpdate()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 88)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:Show()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 136)
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

-- Register event to update action bars when the player enters the world
local ActionBarEvents = CreateFrame("Frame")
ActionBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBarEvents:SetScript("OnEvent", ActionBarUpdate)

-- Function to update action button usability and range
function ActionButtonUpdate(self)
    if self.action then
        local ActionRange = IsActionInRange(self.action)
        local ActionUsability = IsUsableAction(self.action)
        
        if not ActionUsability or ActionRange == false then
            self.icon:SetVertexColor(0.25, 0.25, 0.25, 1)
        else
            self.icon:SetVertexColor(1, 1, 1, 1)
        end
    end
end

-- Hook the action button update function
hooksecurefunc("ActionButton_OnUpdate", ActionButtonUpdate)

-- Function to update text outlines on action buttons
local function UpdateTextOutlines()
    local function updateButtonFonts(button)
        if button then
            local macroName = _G[button:GetName() .. "Name"]
            if macroName then
                macroName:SetFont(macroName:GetFont(), 10, "OUTLINE")
                macroName:SetTextColor(1, 1, 1, 0.75)
            end
            local hotkey = _G[button:GetName() .. "HotKey"]
            if hotkey then
                hotkey:SetFont(hotkey:GetFont(), 12, "OUTLINE")
                hotkey:SetTextColor(1, 1, 1, 0.75)
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
        updateButtonFonts(_G["ActionButton" .. i])
        updateButtonFonts(_G["MultiBarBottomLeftButton" .. i])
        updateButtonFonts(_G["MultiBarBottomRightButton" .. i])
        updateButtonFonts(_G["MultiBarRightButton" .. i])
        updateButtonFonts(_G["MultiBarLeftButton" .. i])
    end
end

-- Register event to update text outlines when the player enters the world
local TextOutlineEvents = CreateFrame("Frame")
TextOutlineEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TextOutlineEvents:SetScript("OnEvent", UpdateTextOutlines)

-- Function to update the pet action bar
local function PetBarUpdate()
    local PreviousPetButton

    for numStances = 1, 10 do
        local PetButton = _G["PetActionButton" .. numStances]
        PetButton:ClearAllPoints()

        if not PreviousPetButton then
            PetButton:SetPoint("BOTTOMLEFT", MultiBarBottomLeft, "TOPLEFT", 0, 8)
        else
            PetButton:SetPoint("LEFT", PreviousPetButton, "RIGHT", 4, 0)
        end

        PetButton:SetScale(0.8)
        PetButton:SetAlpha(0.5)
        PetButton:Show()

        PreviousPetButton = PetButton
    end
end

-- Register events to update the pet action bar
local PetBarEvents = CreateFrame("Frame")
PetBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PetBarEvents:RegisterEvent("UNIT_PET")
PetBarEvents:RegisterEvent("PET_BAR_UPDATE")
PetBarEvents:SetScript("OnEvent", PetBarUpdate)

-- Function to update the class stance bar
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

-- Register events to update the class stance bar
local ClassBarEvents = CreateFrame("Frame")
ClassBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ClassBarEvents:RegisterEvent("UPDATE_STEALTH")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
ClassBarEvents:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
ClassBarEvents:RegisterEvent("PLAYER_REGEN_ENABLED")
ClassBarEvents:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        ClassBarUpdate()
    else
        ClassBarUpdate()
    end
end)

-- Function to update the vehicle leave button
local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(36, 36)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
end

-- Hook the vehicle leave button update function
MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)