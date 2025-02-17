local function UpdateTooltip(tooltip)
    if tooltip:GetAnchorType() ~= "ANCHOR_CURSOR" then
        tooltip:ClearAllPoints()
        tooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -4)
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOP", tooltip, "BOTTOM", 0, 4)
        GameTooltipStatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        GameTooltipStatusBar:SetFrameLevel(tooltip:GetFrameLevel() - 1)
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", UpdateTooltip)
GameTooltip:HookScript("OnTooltipSetUnit", UpdateTooltip)
GameTooltip:HookScript("OnSizeChanged", function() GameTooltipStatusBar:Hide() end)