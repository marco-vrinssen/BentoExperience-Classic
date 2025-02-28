-- UPDATE MINIMAP

local function MinimapContainerUpdate()
    Minimap:SetClampedToScreen(false)
    Minimap:SetParent(UIParent)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    MinimapBackdrop:Hide()
    GameTimeFrame:Hide()
    MinimapCluster:Hide()
end

local MinimapContainerFrame = CreateFrame("Frame")
MinimapContainerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapContainerFrame:RegisterEvent("ZONE_CHANGED")
MinimapContainerFrame:SetScript("OnEvent", MinimapContainerUpdate)




-- ENABLE MOUSE WHEEL ZOOM ON MINIMAP

local function MinimapScrollEnable(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

local MinimapZoomFrame = CreateFrame("Frame", nil, Minimap)
MinimapZoomFrame:SetAllPoints(Minimap)
MinimapZoomFrame:EnableMouseWheel(true)
MinimapZoomFrame:SetScript("OnMouseWheel", MinimapScrollEnable)




-- UPDATE MINIMAP TIME DISPLAY

local MinimapTimeBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
MinimapTimeBackdrop:SetSize(48, 24)
MinimapTimeBackdrop:SetPoint("CENTER", Minimap, "BOTTOM", 0, -2)
MinimapTimeBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = EDGE,
      edgeSize = MEDIUM,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapTimeBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
MinimapTimeBackdrop:SetBackdropBorderColor(unpack(GREY))
MinimapTimeBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

local function MinimapTimeUpdate()
    for _, ButtonRegion in pairs({TimeManagerClockButton:GetRegions()}) do
        if ButtonRegion:IsObjectType("Texture") then
            ButtonRegion:Hide()
        end
    end
    TimeManagerClockButton:SetParent(MinimapTimeBackdrop)
    TimeManagerClockButton:SetAllPoints(MinimapTimeBackdrop)
    TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 0)
    TimeManagerClockTicker:SetFont(FONT, MEDIUM)
    TimeManagerFrame:ClearAllPoints()
    TimeManagerFrame:SetPoint("TOPRIGHT", MinimapTimeBackdrop, "BOTTOMRIGHT", 0, -4)
end

local MinimapTimeFrame = CreateFrame("Frame")
MinimapTimeFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapTimeFrame:SetScript("OnEvent", MinimapTimeUpdate)




-- UPDATE MINIMAP MAIL ICON

local MinimapMailBackdrop = CreateFrame("Frame", nil, MiniMapMailFrame, "BackdropTemplate")
MinimapMailBackdrop:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -4, 4)
MinimapMailBackdrop:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 4, -4)
MinimapMailBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = EDGE,
    edgeSize = MEDIUM,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapMailBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
MinimapMailBackdrop:SetBackdropBorderColor(unpack(GREY))
MinimapMailBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

local function MinimapMailUpdate()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetSize(16, 16)
    MiniMapMailFrame:SetPoint("RIGHT", MinimapTimeBackdrop, "LEFT", -4, 0)
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetSize(18, 18)
    MiniMapMailIcon:SetPoint("CENTER", MiniMapMailFrame, "CENTER", 0, 0)
end

local MinimapMailFrame = CreateFrame("Frame")
MinimapMailFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapMailFrame:SetScript("OnEvent", MinimapMailUpdate)




-- UPDATE MINIMAP BATTLEFIELD ICON

local MinimapBFBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
MinimapBFBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
MinimapBFBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
MinimapBFBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = EDGE,
      edgeSize = MEDIUM,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapBFBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
MinimapBFBackdrop:SetBackdropBorderColor(unpack(GREY))
MinimapBFBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

local function MinimapBFUpdate()
    MiniMapBattlefieldBorder:Hide()
    BattlegroundShine:Hide()
    MiniMapBattlefieldFrame:SetParent(Minimap)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetSize(16, 16)
    MiniMapBattlefieldFrame:SetPoint("LEFT", MinimapTimeBackdrop, "RIGHT", 4, 0)
    MiniMapBattlefieldIcon:ClearAllPoints()
    MiniMapBattlefieldIcon:SetSize(16, 16)
    MiniMapBattlefieldIcon:SetPoint("CENTER", MiniMapBattlefieldFrame, "CENTER", 0, 0)
end

local MinimapBFFrame = CreateFrame("Frame")
MinimapBFFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapBFFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
MinimapBFFrame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
MinimapBFFrame:SetScript("OnEvent", MinimapBFUpdate)




-- UPDATE MINIMAP TRACKING ICON

local MinimapTrackingBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
MinimapTrackingBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
MinimapTrackingBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
MinimapTrackingBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = EDGE,
      edgeSize = MEDIUM,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapTrackingBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
MinimapTrackingBackdrop:SetBackdropBorderColor(unpack(GREY))
MinimapTrackingBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

local function MinimapTrackingUpdate()
    MiniMapTrackingBorder:Hide()
    MiniMapTracking:SetParent(Minimap)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetSize(12, 12)
    MiniMapTracking:SetPoint("TOP", Minimap, "TOP", 0, 0)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetSize(13, 13)
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTracking, "CENTER", 0, 0)
end

local MinimapTrackingFrame = CreateFrame("Frame")
MinimapTrackingFrame:RegisterEvent("MINIMAP_UPDATE_TRACKING")
MinimapTrackingFrame:SetScript("OnEvent", function()
    C_Timer.After(0.1, MinimapTrackingUpdate)
end)