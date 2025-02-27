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