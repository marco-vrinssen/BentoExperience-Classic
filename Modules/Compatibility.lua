-- UPDATE AUCTIONATOR SCAN BUTTON POSITION

local function UpdateAuctionator()
    if not IsAddOnLoaded("Auctionator") then
        return
    end

    local ScanButton = AuctionatorConfigFrame.ScanButton
    ScanButton:SetParent(AuctionFrame)
    ScanButton:ClearAllPoints()
    ScanButton:SetPoint("RIGHT", AuctionFrameCloseButton, "LEFT", -20, 0)
end

local AuctionatorEvents = CreateFrame("Frame")
AuctionatorEvents:RegisterEvent("AUCTION_HOUSE_SHOW")
AuctionatorEvents:SetScript("OnEvent", UpdateAuctionator)




-- UPDATE QUESTIE TRACKING ICONS

local function UpdateQuestieIcons()
    if not IsAddOnLoaded("Questie") then
        return
    end

    local function PositionQuestieIcons()
        if QuestieNameplate then
            QuestieNameplate:SetScale(1.2)
            QuestieNameplate:ClearAllPoints()
            QuestieNameplate:SetPoint("LEFT", NameplateHealthbar, "RIGHT", -16, 0)
        end

        if QuestieTargetFrame then
            QuestieTargetFrame:SetScale(1.5)
            QuestieTargetFrame:ClearAllPoints()
            QuestieTargetFrame:SetPoint("CENTER", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
            QuestieTargetFrame:SetFrameLevel(TargetPortraitBackdrop:GetFrameLevel() + 1)
        end
    end

    local QuestieSupportEvents = CreateFrame("Frame")
    QuestieSupportEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
    QuestieSupportEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
    QuestieSupportEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    QuestieSupportEvents:SetScript("OnEvent", UpdateQuestieIcons)
end