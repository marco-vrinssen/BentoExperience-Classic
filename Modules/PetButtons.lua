-- Hide textures of pet action buttons
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

-- Update the pet action bar
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


-- Update the vehicle leave button
local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(36, 36)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)