local function PlayerAurasUpdate()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 0)
end

local PlayerAurasEvents = CreateFrame("Frame")
PlayerAurasEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerAurasEvents:RegisterEvent("UNIT_AURA")
PlayerAurasEvents:SetScript("OnEvent", PlayerAurasUpdate)