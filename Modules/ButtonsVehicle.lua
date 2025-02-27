-- UPDATE VEHICLE LEAVE BUTTON

local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(24, 24)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", PlayerPortrait, "TOPLEFT", -2, 2)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)