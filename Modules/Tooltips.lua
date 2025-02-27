-- UPDATE TOOLTIP

local function UpdateTooltip(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -4)
    end
end

GameTooltipStatusBar:SetScript("OnShow", function(self)
    self:Hide()
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", UpdateTooltip)