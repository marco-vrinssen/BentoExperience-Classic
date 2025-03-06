-- UPDATE MINIMAP

local function updateMinimap()
    Minimap:SetClampedToScreen(false)
    Minimap:SetParent(UIParent)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    MinimapBackdrop:Hide()
    GameTimeFrame:Hide()
    MinimapCluster:Hide()
end

local minimapEvents = CreateFrame("Frame")
minimapEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapEvents:RegisterEvent("ZONE_CHANGED")
minimapEvents:SetScript("OnEvent", updateMinimap)


-- ENABLE MOUSE WHEEL ZOOM ON MINIMAP

local function enableMinimapScroll(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

local zoomEvents = CreateFrame("Frame", nil, Minimap)
zoomEvents:SetAllPoints(Minimap)
zoomEvents:EnableMouseWheel(true)
zoomEvents:SetScript("OnMouseWheel", enableMinimapScroll)


-- UPDATE MINIMAP TIME DISPLAY

local minimapTimeBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
minimapTimeBackdrop:SetSize(48, 24)
minimapTimeBackdrop:SetPoint("CENTER", Minimap, "BOTTOM", 0, -2)
minimapTimeBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapTimeBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
minimapTimeBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapTimeBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateMinimapTimer()
    for _, buttonRegion in pairs({TimeManagerClockButton:GetRegions()}) do
        if buttonRegion:IsObjectType("Texture") then
            buttonRegion:Hide()
        end
    end
    TimeManagerClockButton:SetParent(minimapTimeBackdrop)
    TimeManagerClockButton:SetAllPoints(minimapTimeBackdrop)
    TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 0)
    TimeManagerClockTicker:SetFont(FONT, 12)
    TimeManagerFrame:ClearAllPoints()
    TimeManagerFrame:SetPoint("TOPRIGHT", minimapTimeBackdrop, "BOTTOMRIGHT", 0, -4)
end

local minimapTimerEvents = CreateFrame("Frame")
minimapTimerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapTimerEvents:SetScript("OnEvent", updateMinimapTimer)


-- UPDATE MINIMAP MAIL ICON

local minimapMailBackdrop = CreateFrame("Frame", nil, MiniMapMailFrame, "BackdropTemplate")
minimapMailBackdrop:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -4, 4)
minimapMailBackdrop:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 4, -4)
minimapMailBackdrop:SetBackdrop({
    bgFile = BG,
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapMailBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
minimapMailBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapMailBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateMinimapMail()
    MiniMapMailBorder:Hide()
    MiniMapMailFrame:SetParent(Minimap)
    MiniMapMailFrame:ClearAllPoints()
    MiniMapMailFrame:SetSize(16, 16)
    MiniMapMailFrame:SetPoint("RIGHT", minimapTimeBackdrop, "LEFT", -4, 0)
    MiniMapMailIcon:ClearAllPoints()
    MiniMapMailIcon:SetSize(18, 18)
    MiniMapMailIcon:SetPoint("CENTER", MiniMapMailFrame, "CENTER", 0, 0)
end

local minimapMailEvents = CreateFrame("Frame")
minimapMailEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapMailEvents:SetScript("OnEvent", updateMinimapMail)


-- UPDATE MINIMAP BATTLEFIELD ICON

local minimapBFBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
minimapBFBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
minimapBFBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
minimapBFBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapBFBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
minimapBFBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapBFBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function minimapBFUpdate()
    MiniMapBattlefieldBorder:Hide()
    BattlegroundShine:Hide()
    MiniMapBattlefieldFrame:SetParent(Minimap)
    MiniMapBattlefieldFrame:ClearAllPoints()
    MiniMapBattlefieldFrame:SetSize(16, 16)
    MiniMapBattlefieldFrame:SetPoint("LEFT", minimapTimeBackdrop, "RIGHT", 4, 0)
    MiniMapBattlefieldIcon:ClearAllPoints()
    MiniMapBattlefieldIcon:SetSize(16, 16)
    MiniMapBattlefieldIcon:SetPoint("CENTER", MiniMapBattlefieldFrame, "CENTER", 0, 0)
end

local minimapBFFrame = CreateFrame("Frame")
minimapBFFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
minimapBFFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
minimapBFFrame:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
minimapBFFrame:SetScript("OnEvent", minimapBFUpdate)



-- UPDATE MINIMAP TRACKING ICON

local minimapTrackingBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
minimapTrackingBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
minimapTrackingBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
minimapTrackingBackdrop:SetBackdrop({
    bgFile = BG, -- Updated background
    edgeFile = BORD,
    edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
minimapTrackingBackdrop:SetBackdropColor(0, 0, 0, 1) -- Commented out custom coloring
minimapTrackingBackdrop:SetBackdropBorderColor(unpack(GREY))
minimapTrackingBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 2)

local function updateTracking()
    MiniMapTrackingBorder:Hide()
    MiniMapTracking:SetParent(Minimap)
    MiniMapTracking:ClearAllPoints()
    MiniMapTracking:SetSize(12, 12)
    MiniMapTracking:SetPoint("TOP", Minimap, "TOP", 0, 0)
    MiniMapTrackingIcon:ClearAllPoints()
    MiniMapTrackingIcon:SetSize(13, 13)
    MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTracking, "CENTER", 0, 0)
end

local trackingEvents = CreateFrame("Frame")
trackingEvents:RegisterEvent("MINIMAP_UPDATE_TRACKING")
trackingEvents:SetScript("OnEvent", function()
    C_Timer.After(0.1, updateTracking)
end)