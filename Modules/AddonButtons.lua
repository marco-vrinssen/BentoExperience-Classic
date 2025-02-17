-- Function to update addon buttons
local function AddonButtonUpdate()
    local LibDBIcon = _G.LibStub and _G.LibStub("LibDBIcon-1.0", true)
    if not LibDBIcon then return end

    local buttons = {}
    for name, AddonButton in pairs(LibDBIcon.objects) do
        table.insert(buttons, {name = name, button = AddonButton})
    end
    table.sort(buttons, function(a, b) return a.name < b.name end)

    for _, data in ipairs(buttons) do
        local AddonButton = data.button
        if AddonButton:IsShown() then
            for i = 1, AddonButton:GetNumRegions() do
                local ButtonRegion = select(i, AddonButton:GetRegions())
                if ButtonRegion:IsObjectType("Texture") and ButtonRegion ~= AddonButton.icon then
                    ButtonRegion:Hide()
                end
            end

            AddonButton:SetSize(16, 16)
            AddonButton:SetParent(UIParent)
            AddonButton:SetFrameLevel(Minimap:GetFrameLevel() + 1)
            AddonButton:SetAlpha(0.75)
            AddonButton.icon:ClearAllPoints()
            AddonButton.icon:SetPoint("CENTER", AddonButton, "CENTER", 0, 0)
            AddonButton.icon:SetSize(14, 14)

            if not AddonButton.background then
                AddonButton.background = CreateFrame("Frame", nil, AddonButton, BackdropTemplateMixin and "BackdropTemplate")
                AddonButton.background:SetPoint("TOPLEFT", AddonButton, "TOPLEFT", -4, 4)
                AddonButton.background:SetPoint("BOTTOMRIGHT", AddonButton, "BOTTOMRIGHT", 4, -4)
                AddonButton.background:SetBackdrop({
                    bgFile = "Interface/ChatFrame/ChatFrameBackground",
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    tile = false, tileSize = 16, edgeSize = 12,
                    insets = {left = 2, right = 2, top = 2, bottom = 2}
                })
                AddonButton.background:SetBackdropColor(0, 0, 0, 1)
                AddonButton.background:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
                AddonButton.background:SetFrameLevel(AddonButton:GetFrameLevel() - 1)
            end
        end
    end
end

-- Register events to update addon buttons when the player enters the world or an addon is loaded
local AddonButtonEvents = CreateFrame("Frame")
AddonButtonEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
AddonButtonEvents:RegisterEvent("ADDON_LOADED")
AddonButtonEvents:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0, AddonButtonUpdate)
    end
end)