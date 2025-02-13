local function FramerateUpdate()
    FramerateLabel:SetAlpha(0)
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", UIParent, "TOP", 0, -16)
end

local FramerateEvents = CreateFrame("Frame")
FramerateEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
FramerateEvents:SetScript("OnEvent", FramerateUpdate)