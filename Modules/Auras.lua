local function UpdateCustomTimerText(buff)
    local duration = _G[buff:GetName().."Duration"]
    if duration then
        duration:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
        duration:SetTextColor(1, 1, 1)
        duration:ClearAllPoints()
        duration:SetPoint("BOTTOM", buff, "BOTTOM", 0, -12)
        duration:SetAlpha(0.75)
    end
end

local function UpdateBuffFramePosition()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -40, 0)
end

local function UpdatePlayerAuras()
    UpdateBuffFramePosition()
    for i = 1, BUFF_MAX_DISPLAY do
        local buff = _G["BuffButton"..i]
        if buff then
            UpdateCustomTimerText(buff)
        end
    end
end

local function PlayerAurasOnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_AURA" then
        UpdatePlayerAuras()
    end
end

local function InitializePlayerAurasEvents()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("UNIT_AURA")
    frame:SetScript("OnEvent", PlayerAurasOnEvent)
end

InitializePlayerAurasEvents()

hooksecurefunc("AuraButton_UpdateDuration", function(buff)
    UpdateCustomTimerText(buff)
end)