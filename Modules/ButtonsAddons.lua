-- UPDATE ADDON BUTTONS ON MINIMAP

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
            AddonButton.icon:ClearAllPoints()
            AddonButton.icon:SetPoint("CENTER", AddonButton, "CENTER", 0, 0)
            AddonButton.icon:SetSize(12, 12)

            if not AddonButton.background then
                AddonButton.background = CreateFrame("Frame", nil, AddonButton, BackdropTemplateMixin and "BackdropTemplate")
                AddonButton.background:SetPoint("TOPLEFT", AddonButton, "TOPLEFT", -3, 3)
                AddonButton.background:SetPoint("BOTTOMRIGHT", AddonButton, "BOTTOMRIGHT", 3, -3)
                AddonButton.background:SetBackdrop({
                    bgFile = BG,
                    edgeFile = EDGE,
                    edgeSize = MEDIUM,
                    insets = {left = 2, right = 2, top = 2, bottom = 2}
                })
                AddonButton.background:SetBackdropColor(unpack(BLACK))
                AddonButton.background:SetBackdropBorderColor(unpack(GREY))
                AddonButton.background:SetFrameLevel(AddonButton:GetFrameLevel() - 1)
            end
        end
    end
end

local AddonButtonFrame = CreateFrame("Frame")
AddonButtonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
AddonButtonFrame:RegisterEvent("ADDON_LOADED")
AddonButtonFrame:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0, AddonButtonUpdate)
    end
end)