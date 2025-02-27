-- UPDATE MICRO MENU BUTTON POSITION

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
            button:SetAlpha(0.8)
            button:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", xOffset, 24)
            button:Show()
            xOffset = xOffset - button:GetWidth()
        end
    end
end

local microMenuEventFrame = CreateFrame("Frame")
microMenuEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
microMenuEventFrame:SetScript("OnEvent", UpdateMicroMenuButtons)

hooksecurefunc("UpdateMicroButtons", UpdateMicroMenuButtons)