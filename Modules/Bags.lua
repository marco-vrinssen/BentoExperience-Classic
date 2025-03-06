-- CUSTOMIZE BAG SLOT BUTTONS

local function customizeBagSlot(button)
    if button and not button.customBorder then
        local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
        backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
        backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
        backdrop:SetBackdrop({
            edgeFile = BORD,
            edgeSize = 12
        })
        backdrop:SetBackdropBorderColor(unpack(GREY))
        backdrop:SetFrameLevel(button:GetFrameLevel() + 2)
        button.customBorder = backdrop
        
        local normalTexture = _G[button:GetName().."NormalTexture"]
        if normalTexture then
            normalTexture:SetAlpha(0)
            normalTexture:Hide()
        end
        
        local iconTexture = _G[button:GetName().."IconTexture"]
        if iconTexture then
            iconTexture:ClearAllPoints()
            iconTexture:SetPoint("TOPLEFT", button, "TOPLEFT", 0, -0)
            iconTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -0, 0)
            iconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        end
    end
end


-- UPDATE BAG SLOTS

local function updateBagSlots()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", HelpMicroButton, "TOPRIGHT", -4, -16)
    customizeBagSlot(MainMenuBarBackpackButton)

    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, 0)
    CharacterBag0Slot:SetParent(ContainerFrame1)
    customizeBagSlot(CharacterBag0Slot)

    CharacterBag1Slot:ClearAllPoints()
    CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -4, 0)
    CharacterBag1Slot:SetParent(ContainerFrame1)
    customizeBagSlot(CharacterBag1Slot)

    CharacterBag2Slot:ClearAllPoints()
    CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -4, 0)
    CharacterBag2Slot:SetParent(ContainerFrame1)
    customizeBagSlot(CharacterBag2Slot)

    CharacterBag3Slot:ClearAllPoints()
    CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -4, 0)
    CharacterBag3Slot:SetParent(ContainerFrame1)
    customizeBagSlot(CharacterBag3Slot)

    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -4, -1)
    KeyRingButton:SetParent(ContainerFrame1)
    customizeBagSlot(KeyRingButton)
end

local bagSlotEvents = CreateFrame("Frame")
bagSlotEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagSlotEvents:RegisterEvent("BAG_UPDATE")
bagSlotEvents:SetScript("OnEvent", updateBagSlots)


-- UPDATE BAG CONTAINERS

local function updateContainers()
    local openPlayerContainers = {}
    local openBankContainers = {}
    local lastPlayerContainer = MainMenuBarBackpackButton
    local bankFrame = BankFrame
    
    for i = 0, NUM_BAG_FRAMES + NUM_BANKBAGSLOTS do
        local ContainerFrame = _G["ContainerFrame"..(i+1)]
        if ContainerFrame and ContainerFrame:IsShown() then
            if ContainerFrame:GetID() >= 5 then
                table.insert(openBankContainers, ContainerFrame)
            else
                table.insert(openPlayerContainers, ContainerFrame)
            end
        end
    end
    
    for i, ContainerFrame in ipairs(openPlayerContainers) do
        ContainerFrame:ClearAllPoints()
        if i == 1 then
            ContainerFrame:SetPoint("BOTTOMRIGHT", lastPlayerContainer, "TOPRIGHT", 4, 4)
        elseif i == 2 then
            ContainerFrame:SetPoint("BOTTOM", openPlayerContainers[1], "TOP", 0, 8)
        elseif i == 3 then
            ContainerFrame:SetPoint("BOTTOM", openPlayerContainers[2], "TOP", 0, 8)
        elseif i == 4 then
            ContainerFrame:SetPoint("BOTTOMRIGHT", openPlayerContainers[2], "BOTTOMLEFT", -8, 0)
        elseif i == 5 then
            ContainerFrame:SetPoint("BOTTOM", openPlayerContainers[4], "TOP", 0, 8)
        elseif i == 6 then
            ContainerFrame:SetPoint("TOPRIGHT", openPlayerContainers[5], "TOPLEFT", -8, 0)
        else
            ContainerFrame:SetPoint("TOPRIGHT", openPlayerContainers[i-1], "TOPLEFT", -8, 0)
        end
    end
    
    for i, ContainerFrame in ipairs(openBankContainers) do
        ContainerFrame:ClearAllPoints()
        if i == 1 then
            ContainerFrame:SetPoint("TOPLEFT", bankFrame, "TOPRIGHT", 4, 0)
        elseif i == 2 then
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[1], "TOPRIGHT", 4, 0)
        elseif i == 3 then
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[2], "TOPRIGHT", 4, 0)
        elseif i == 4 then
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[1], "BOTTOMLEFT", 0, -8)
        elseif i == 5 then
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[4], "TOPRIGHT", 4, 0)
        elseif i == 6 then
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[5], "TOPRIGHT", 4, 0)
        else
            ContainerFrame:SetPoint("TOPLEFT", openBankContainers[i-1], "TOPRIGHT", 4, 0)
        end
    end
    
    if not IsBagOpen(0) then
        if IsBagOpen(KEYRING_CONTAINER) then
            ToggleBag(KEYRING_CONTAINER)
        end
    end
end

hooksecurefunc("UpdateContainerFrameAnchors", updateContainers)

local bagContainerEvents = CreateFrame("Frame")
bagContainerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagContainerEvents:RegisterEvent("BAG_UPDATE")
bagContainerEvents:RegisterEvent("BANKFRAME_OPENED")
bagContainerEvents:RegisterEvent("BANKFRAME_CLOSED")
bagContainerEvents:RegisterEvent("MERCHANT_SHOW")
bagContainerEvents:RegisterEvent("MERCHANT_CLOSED")
bagContainerEvents:SetScript("OnEvent", updateContainers)


-- ENABLE AUTOMATIC BAG TOGGLE

local function togglePlayerBags()
    if IsBagOpen(0) then
        CloseAllBags()
    else
        OpenAllBags()
    end
end

MainMenuBarBackpackButton:SetScript("OnClick", togglePlayerBags)


-- ENABLE AUTOMATIC BANK BAG TOGGLE

local function openBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        OpenBag(bagID)
    end
end

local function closeBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        CloseBag(bagID)
    end
end

local bagToggleEvents = CreateFrame("Frame")
bagToggleEvents:RegisterEvent("BANKFRAME_OPENED")
bagToggleEvents:RegisterEvent("BANKFRAME_CLOSED")
bagToggleEvents:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        openBankBags()
    elseif event == "BANKFRAME_CLOSED" then
        closeBankBags()
    end
end)


-- CUSTOMIZE BANK BAG SLOTS

local function customizeBankBagSlots()
    for i = 1, NUM_BANKBAGSLOTS do
        local bankBagSlot = _G["BankFrameBag"..i]
        if bankBagSlot then
            customizeBagSlot(bankBagSlot)
        end
    end
    customizeBagSlot(BankFrameBagButton)
end

local bagCustomizationEvents = CreateFrame("Frame")
bagCustomizationEvents:RegisterEvent("BANKFRAME_OPENED")
bagCustomizationEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
bagCustomizationEvents:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        customizeBankBagSlots()
    elseif event == "PLAYER_ENTERING_WORLD" then
        updateBagSlots()
    end
end)