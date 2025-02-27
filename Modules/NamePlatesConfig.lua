-- UPDATE NAMEPLATE CONFIG

local function NameplateConfigUpdate()
    SetCVar("nameplateMinScale", 0.8)
end

local NameplateConfigEvents = CreateFrame("Frame")
NameplateConfigEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
NameplateConfigEvents:SetScript("OnEvent", NameplateConfigUpdate)