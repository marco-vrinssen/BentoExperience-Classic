-- Update the vehicle leave button
local function VehicleButtonUpdate()
    MainMenuBarVehicleLeaveButton:SetSize(36, 36)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("CENTER", UIParent, "CENTER", 0, -160)
end

MainMenuBarVehicleLeaveButton:HookScript("OnShow", VehicleButtonUpdate)