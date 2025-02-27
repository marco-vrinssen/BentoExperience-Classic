-- UPDATE BAG SLOTS

local function BagSlotUpdate()
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", HelpMicroButton, "TOPRIGHT", -2, -12)
    MainMenuBarBackpackButton:SetScale(0.8)

    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -4, 0)
    CharacterBag0Slot:SetScale(0.8)
    CharacterBag0Slot:SetParent(ContainerFrame1)

    CharacterBag1Slot:ClearAllPoints()
    CharacterBag1Slot:SetPoint("RIGHT", CharacterBag0Slot, "LEFT", -4, 0)
    CharacterBag1Slot:SetScale(0.8)
    CharacterBag1Slot:SetParent(ContainerFrame1)

    CharacterBag2Slot:ClearAllPoints()
    CharacterBag2Slot:SetPoint("RIGHT", CharacterBag1Slot, "LEFT", -4, 0)
    CharacterBag2Slot:SetScale(0.8)
    CharacterBag2Slot:SetParent(ContainerFrame1)

    CharacterBag3Slot:ClearAllPoints()
    CharacterBag3Slot:SetPoint("RIGHT", CharacterBag2Slot, "LEFT", -4, 0)
    CharacterBag3Slot:SetScale(0.8)
    CharacterBag3Slot:SetParent(ContainerFrame1)

    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", -4, -1)
    KeyRingButton:SetScale(0.8)
    KeyRingButton:SetParent(ContainerFrame1)
end

local BagSlotFrame = CreateFrame("Frame")
BagSlotFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagSlotFrame:RegisterEvent("BAG_UPDATE")
BagSlotFrame:SetScript("OnEvent", BagSlotUpdate)


-- UPDATE BAG CONTAINERS

local function BagContainerUpdate()
    local OpenPlayerContainers = {}
    local OpenBankContainers = {}
    local LastPlayerContainer = MainMenuBarBackpackButton
    local BankFrame = BankFrame
    
    for i = 0, NUM_BAG_FRAMES + NUM_BANKBAGSLOTS do
        local ContainerFrame = _G["ContainerFrame"..(i+1)]
        if ContainerFrame and ContainerFrame:IsShown() then
            if ContainerFrame:GetID() >= 5 then
                table.insert(OpenBankContainers, ContainerFrame)
            else
                table.insert(OpenPlayerContainers, ContainerFrame)
            end
        end
    end
    
    for i, ContainerFrame in ipairs(OpenPlayerContainers) do
        ContainerFrame:ClearAllPoints()
        if i == 1 then
            ContainerFrame:SetPoint("BOTTOMRIGHT", LastPlayerContainer, "TOPRIGHT", 4, 4)
        elseif i == 2 then
            ContainerFrame:SetPoint("BOTTOM", OpenPlayerContainers[1], "TOP", 0, 8)
        elseif i == 3 then
            ContainerFrame:SetPoint("BOTTOM", OpenPlayerContainers[2], "TOP", 0, 8)
        elseif i == 4 then
            ContainerFrame:SetPoint("BOTTOMRIGHT", OpenPlayerContainers[2], "BOTTOMLEFT", -8, 0)
        elseif i == 5 then
            ContainerFrame:SetPoint("BOTTOM", OpenPlayerContainers[4], "TOP", 0, 8)
        elseif i == 6 then
            ContainerFrame:SetPoint("TOPRIGHT", OpenPlayerContainers[5], "TOPLEFT", -8, 0)
        else
            ContainerFrame:SetPoint("TOPRIGHT", OpenPlayerContainers[i-1], "TOPLEFT", -8, 0)
        end
    end
    
    for i, ContainerFrame in ipairs(OpenBankContainers) do
        ContainerFrame:ClearAllPoints()
        if i == 1 then
            ContainerFrame:SetPoint("TOPLEFT", BankFrame, "TOPRIGHT", 4, 0)
        elseif i == 2 then
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[1], "TOPRIGHT", 4, 0)
        elseif i == 3 then
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[2], "TOPRIGHT", 4, 0)
        elseif i == 4 then
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[1], "BOTTOMLEFT", 0, -8)
        elseif i == 5 then
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[4], "TOPRIGHT", 4, 0)
        elseif i == 6 then
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[5], "TOPRIGHT", 4, 0)
        else
            ContainerFrame:SetPoint("TOPLEFT", OpenBankContainers[i-1], "TOPRIGHT", 4, 0)
        end
    end
    
    if not IsBagOpen(0) then
        if IsBagOpen(KEYRING_CONTAINER) then
            ToggleBag(KEYRING_CONTAINER)
        end
    end
end

hooksecurefunc("UpdateContainerFrameAnchors", BagContainerUpdate)

local BagContainerFrame = CreateFrame("Frame")
BagContainerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
BagContainerFrame:RegisterEvent("BAG_UPDATE")
BagContainerFrame:RegisterEvent("BANKFRAME_OPENED")
BagContainerFrame:RegisterEvent("BANKFRAME_CLOSED")
BagContainerFrame:RegisterEvent("MERCHANT_SHOW")
BagContainerFrame:RegisterEvent("MERCHANT_CLOSED")
BagContainerFrame:SetScript("OnEvent", BagContainerUpdate)


-- ENABLE AUTOMATIC BAG TOGGLE

local function TogglePlayerBags()
    if IsBagOpen(0) then
        CloseAllBags()
    else
        OpenAllBags()
    end
end

MainMenuBarBackpackButton:SetScript("OnClick", TogglePlayerBags)


-- ENABLE AUTOMATIC BANK BAG TOGGLE

local function OpenBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        OpenBag(bagID)
    end
end

local function CloseBankBags()
    for bagID = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
        CloseBag(bagID)
    end
end

local BagToggleFrame = CreateFrame("Frame")
BagToggleFrame:RegisterEvent("BANKFRAME_OPENED")
BagToggleFrame:RegisterEvent("BANKFRAME_CLOSED")
BagToggleFrame:SetScript("OnEvent", function(self, event)
    if event == "BANKFRAME_OPENED" then
        OpenBankBags()
    elseif event == "BANKFRAME_CLOSED" then
        CloseBankBags()
    end
end)