-- UPDATE TOOLTIP POSITION

local function updateTooltipPos(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -4)
    end
end

GameTooltipStatusBar:SetScript("OnShow", function()
    GameTooltipStatusBar:Hide()
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", updateTooltipPos)