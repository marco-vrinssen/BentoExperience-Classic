local function UpdateMicroMenuButtons()
    local microButtons = {
        "HelpMicroButton", "MainMenuMicroButton", "WorldMapMicroButton", "GuildMicroButton",
        "SocialsMicroButton", "QuestLogMicroButton", "TalentMicroButton", "SpellbookMicroButton",
        "CharacterMicroButton"
    }

    local xOffset = -24
    for _, name in ipairs(microButtons) do
        local button = _G[name]
        if button then
            button:ClearAllPoints()
            button:SetScale(0.8)
            button:SetAlpha(0.75)
            button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", xOffset, 24)
            button:Show()
            xOffset = xOffset - button:GetWidth() - 2
        end
    end
end

local microMenuEventFrame = CreateFrame("Frame")
microMenuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
microMenuEventFrame:SetScript("OnEvent", UpdateMicroMenuButtons)

hooksecurefunc("UpdateMicroButtons", UpdateMicroMenuButtons)







local function MinimapLFGUpdate()
    if LFGMinimapFrameBorder then
        LFGMinimapFrameBorder:Hide()
    end
    if LFGMinimapFrame then
        LFGMinimapFrame:SetParent(Minimap)
        LFGMinimapFrame:ClearAllPoints()
        LFGMinimapFrame:SetSize(44, 44)
        LFGMinimapFrame:SetPoint("RIGHT", CharacterMicroButton, "LEFT", 0, -8)
    end
    if LFGMinimapFrameIcon then
        LFGMinimapFrameIcon:SetSize(40, 40)
        LFGMinimapFrameIcon:SetPoint("CENTER", LFGMinimapFrame, "CENTER", 0, 0)
    end
end

local MinimapLFGEvents = CreateFrame("Frame")
MinimapLFGEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapLFGEvents:SetScript("OnEvent", MinimapLFGUpdate)