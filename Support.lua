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
local function QuestieSupport()
    if IsAddOnLoaded("Questie") then
        Questie.db.profile.nameplateTargetFrameScale = 1.5
        Questie.db.profile.nameplateTargetFrameX = -180
        Questie.db.profile.nameplateTargetFrameY = 0

        Questie.db.profile.nameplateScale = 1.2
        Questie.db.profile.nameplateX = -24
        Questie.db.profile.nameplateY = 0
    end
end

local QuestieSupportEvents = CreateFrame("Frame")
QuestieSupportEvents:RegisterEvent("PLAYER_LOGIN")
QuestieSupportEvents:SetScript("OnEvent", QuestieSupport)