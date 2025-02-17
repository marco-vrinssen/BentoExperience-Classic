-- Function to update the minimap container
local function MinimapContainerUpdate()
    Minimap:SetClampedToScreen(false)
    Minimap:SetParent(UIParent)
    Minimap:ClearAllPoints()
    Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -16, -16)
    MinimapBackdrop:Hide()
    GameTimeFrame:Hide()
    MinimapCluster:Hide()
end

-- Register events to update the minimap container
local MinimapContainerEvents = CreateFrame("Frame")
MinimapContainerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapContainerEvents:RegisterEvent("ZONE_CHANGED")
MinimapContainerEvents:SetScript("OnEvent", MinimapContainerUpdate)

-- Function to enable mouse wheel zoom on the minimap
local function MinimapScrollEnable(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end

-- Enable mouse wheel zoom on the minimap
local MinimapZoomEvents = CreateFrame("Frame", nil, Minimap)
MinimapZoomEvents:SetAllPoints(Minimap)
MinimapZoomEvents:EnableMouseWheel(true)
MinimapZoomEvents:SetScript("OnMouseWheel", MinimapScrollEnable)

-- Create a backdrop for the minimap time display
local MinimapTimeBackdrop = CreateFrame("Frame", nil, Minimap, "BackdropTemplate")
MinimapTimeBackdrop:SetSize(48, 24)
MinimapTimeBackdrop:SetPoint("CENTER", Minimap, "BOTTOM", 0, -2)
MinimapTimeBackdrop:SetBackdrop({
    bgFile = "Interface/ChatFrame/ChatFrameBackground", -- Commented out to prevent black screen
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 24, edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapTimeBackdrop:SetBackdropColor(0, 0, 0, 1)
MinimapTimeBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
MinimapTimeBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

-- Function to update the minimap time display
local function MinimapTimeUpdate()
    for _, ButtonRegion in pairs({TimeManagerClockButton:GetRegions()}) do
        if ButtonRegion:IsObjectType("Texture") then
            ButtonRegion:Hide()
        end
    end
    TimeManagerClockButton:SetParent(MinimapTimeBackdrop)
    TimeManagerClockButton:SetAllPoints(MinimapTimeBackdrop)
    TimeManagerClockTicker:SetPoint("CENTER", TimeManagerClockButton, "CENTER", 0, 0)
    TimeManagerClockTicker:SetFont(STANDARD_TEXT_FONT, 12)
    TimeManagerFrame:ClearAllPoints()
    TimeManagerFrame:SetPoint("TOPRIGHT", MinimapTimeBackdrop, "BOTTOMRIGHT", 0, -4)
end

-- Register event to update the minimap time display
local MinimapTimeEvents = CreateFrame("Frame")
MinimapTimeEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapTimeEvents:SetScript("OnEvent", MinimapTimeUpdate)

-- Create a backdrop for the minimap mail icon
local MinimapMailBackdrop = CreateFrame("Frame", nil, MiniMapMailFrame, "BackdropTemplate")
MinimapMailBackdrop:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -4, 4)
MinimapMailBackdrop:SetPoint("BOTTOMRIGHT", MiniMapMailFrame, "BOTTOMRIGHT", 4, -4)
MinimapMailBackdrop:SetBackdrop({
    bgFile = "Interface/ChatFrame/ChatFrameBackground",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false, tileSize = 16, edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapMailBackdrop:SetBackdropColor(0, 0, 0, 1)
MinimapMailBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
MinimapMailBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

-- Function to update the minimap mail icon
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

-- Register event to update the minimap mail icon
local MinimapMailEvents = CreateFrame("Frame")
MinimapMailEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapMailEvents:SetScript("OnEvent", MinimapMailUpdate)

-- Create a backdrop for the minimap battlefield icon
local MinimapBFBackdrop = CreateFrame("Frame", nil, MiniMapBattlefieldFrame, "BackdropTemplate")
MinimapBFBackdrop:SetPoint("TOPLEFT", MiniMapBattlefieldFrame, "TOPLEFT", -4, 4)
MinimapBFBackdrop:SetPoint("BOTTOMRIGHT", MiniMapBattlefieldFrame, "BOTTOMRIGHT", 4, -4)
MinimapBFBackdrop:SetBackdrop({
    bgFile = "Interface/ChatFrame/ChatFrameBackground",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapBFBackdrop:SetBackdropColor(0, 0, 0, 1)
MinimapBFBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
MinimapBFBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

-- Function to update the minimap battlefield icon
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

-- Register events to update the minimap battlefield icon
local MinimapBFEvents = CreateFrame("Frame")
MinimapBFEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapBFEvents:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
MinimapBFEvents:RegisterEvent("UPDATE_ACTIVE_BATTLEFIELD")
MinimapBFEvents:SetScript("OnEvent", MinimapBFUpdate)

-- Create a backdrop for the minimap tracking icon
local MinimapTrackingBackdrop = CreateFrame("Frame", nil, MiniMapTracking, "BackdropTemplate")
MinimapTrackingBackdrop:SetPoint("TOPLEFT", MiniMapTracking, "TOPLEFT", -4, 4)
MinimapTrackingBackdrop:SetPoint("BOTTOMRIGHT", MiniMapTracking, "BOTTOMRIGHT", 4, -4)
MinimapTrackingBackdrop:SetBackdrop({
    bgFile = "Interface/ChatFrame/ChatFrameBackground",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 12,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
MinimapTrackingBackdrop:SetBackdropColor(0, 0, 0, 1)
MinimapTrackingBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
MinimapTrackingBackdrop:SetFrameLevel(Minimap:GetFrameLevel() + 1)

-- Function to update the minimap tracking icon
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

-- Register event to update the minimap tracking icon
local MinimapTrackingEvents = CreateFrame("Frame")
MinimapTrackingEvents:RegisterEvent("MINIMAP_UPDATE_TRACKING")
MinimapTrackingEvents:SetScript("OnEvent", function()
    C_Timer.After(0.1, MinimapTrackingUpdate)
end)