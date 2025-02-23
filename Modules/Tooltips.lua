-- Create and configure the backdrop for the tooltip status bar
local function CreateTooltipStatusBarBackdrop()
    local backdrop = CreateFrame("Frame", nil, GameTooltipStatusBar, "BackdropTemplate")
    backdrop:SetBackdrop({
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12
    })
    backdrop:SetBackdropBorderColor(0.75, 0.75, 0.75, 1)
    backdrop:SetFrameLevel(GameTooltipStatusBar:GetFrameLevel() + 1)
    return backdrop
end

-- Function to update the tooltip position and appearance
local function UpdateTooltip(self)
    if self:GetAnchorType() ~= "ANCHOR_CURSOR" then
        GameTooltip:ClearAllPoints()
        GameTooltip:SetPoint("TOPLEFT", TargetFramePortrait, "BOTTOMRIGHT", 4, -32)
        
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", GameTooltip, "BOTTOMLEFT", 4, -4)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", GameTooltip, "BOTTOMRIGHT", -4, -4)
        GameTooltipStatusBar:SetHeight(10)
        GameTooltipStatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        GameTooltipStatusBar:SetFrameLevel(GameTooltip:GetFrameLevel() + 1)
        
        -- Apply the backdrop to the tooltip status bar
        if not GameTooltipStatusBar.Backdrop then
            GameTooltipStatusBar.Backdrop = CreateTooltipStatusBarBackdrop()
        end
        local TooltipStatusBarBackdrop = GameTooltipStatusBar.Backdrop
        TooltipStatusBarBackdrop:ClearAllPoints()
        TooltipStatusBarBackdrop:SetPoint("TOPLEFT", GameTooltipStatusBar, "TOPLEFT", -3, 3)
        TooltipStatusBarBackdrop:SetPoint("BOTTOMRIGHT", GameTooltipStatusBar, "BOTTOMRIGHT", 3, -3)
    end
end

-- Hook the UpdateTooltip function to the GameTooltip_SetDefaultAnchor function
hooksecurefunc("GameTooltip_SetDefaultAnchor", UpdateTooltip)