-- Auctionator Scan Button Repositioning

local function AddScanButtonToAuctionFrame()
    if not IsAddOnLoaded("Auctionator") then
        return
    end

    local ScanButton = AuctionatorConfigFrame.ScanButton
    ScanButton:SetParent(AuctionFrame)
    ScanButton:ClearAllPoints()
    ScanButton:SetPoint("TOPRIGHT", AuctionFrame, "BOTTOMRIGHT", 0, 8)
    ScanButton:SetPoint("LEFT", AuctionFrameTab7, "RIGHT", 0, 0)
    ScanButton:SetHeight(24)

    if AuctionatorConfigFrame.OptionsButton then
        AuctionatorConfigFrame.OptionsButton:Hide()
    end
end

local function OnAuctionHouseShow()
    AddScanButtonToAuctionFrame()
end

local AuctionatorEvents = CreateFrame("Frame")
AuctionatorEvents:RegisterEvent("AUCTION_HOUSE_SHOW")
AuctionatorEvents:SetScript("OnEvent", OnAuctionHouseShow)




-- Questie Tracking Repositioning

local function UpdateQuestieIcons()
    if not IsAddOnLoaded("Questie") then
        return
    end

    local function PositionQuestieIcons()
        if QuestieNameplate then
            QuestieNameplate:SetScale(1.2)
            QuestieNameplate:ClearAllPoints()
            QuestieNameplate:SetPoint("LEFT", TargetFramePortrait, "RIGHT", -24, 0)
        end

        if QuestieTargetFrame then
            QuestieTargetFrame:SetScale(1.5)
            QuestieTargetFrame:ClearAllPoints()
            QuestieTargetFrame:SetPoint("TOP", TargetFramePortrait, "BOTTOM", 0, 24)
        end
    end

    local QuestieSupportEvents = CreateFrame("Frame")
    QuestieSupportEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
    QuestieSupportEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
    QuestieSupportEvents:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    QuestieSupportEvents:SetScript("OnEvent", UpdateQuestieIcons)
end