-- Update the stance/class bar
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