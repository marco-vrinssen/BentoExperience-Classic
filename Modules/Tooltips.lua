local function UpdateTooltip(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -4)
        
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 4, -4)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -4, -4)
        GameTooltipStatusBar:SetHeight(12)
        GameTooltipStatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        GameTooltipStatusBar:SetFrameLevel(GameTooltip:GetFrameLevel() + 1)
        
        local TooltipStatusBarBackdrop = GameTooltipStatusBar.Backdrop
        if not TooltipStatusBarBackdrop then
            TooltipStatusBarBackdrop = CreateFrame("Frame", nil, GameTooltipStatusBar, "BackdropTemplate")
            TooltipStatusBarBackdrop:SetBackdrop({
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 12
            })
            TooltipStatusBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
            TooltipStatusBarBackdrop:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() + 1)
            GameTooltipStatusBar.Backdrop = TooltipStatusBarBackdrop
        end
        TooltipStatusBarBackdrop:ClearAllPoints()
        TooltipStatusBarBackdrop:SetPoint("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -3, 3)
        TooltipStatusBarBackdrop:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 3, -3)
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", UpdateTooltip)