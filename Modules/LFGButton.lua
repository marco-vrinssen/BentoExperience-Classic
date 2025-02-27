-- UPDATE LFG BUTTON

local function MinimapLFGUpdate()
    if LFGMinimapFrameBorder then
        LFGMinimapFrameBorder:Hide()
    end
    if LFGMinimapFrame then
        LFGMinimapFrame:SetParent(Minimap)
        LFGMinimapFrame:ClearAllPoints()
        LFGMinimapFrame:SetSize(44, 44)
        LFGMinimapFrame:SetPoint("RIGHT", CharacterMicroButton, "LEFT", 4, -8)
    end
    if LFGMinimapFrameIcon then
        LFGMinimapFrameIcon:SetSize(40, 40)
        LFGMinimapFrameIcon:SetPoint("CENTER", LFGMinimapFrame, "CENTER", 0, 0)
    end
end

local MinimapLFGFrame = CreateFrame("Frame")
MinimapLFGFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapLFGFrame:SetScript("OnEvent", MinimapLFGUpdate)