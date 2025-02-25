-- Update the vehicle leave button
local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(16, 16)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMLEFT", PlayerFrameBackdrop, "TOPLEFT", 0, 2)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)




local function FramerateUpdate()
    FramerateLabel:SetAlpha(0)
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", UIParent, "TOP", 0, -16)
end

local FramerateEvents = CreateFrame("Frame")
FramerateEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
FramerateEvents:SetScript("OnEvent", FramerateUpdate)