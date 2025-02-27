-- UPDATE AND REPOSITION ACTION BARS

local function UpdateActionButtons()
    MainMenuBar:SetWidth(512)
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", -2, 88)
    MainMenuBar:SetMovable(true)
    MainMenuBar:SetUserPlaced(true)

    MultiBarBottomLeft:Show()
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 134)
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    MultiBarBottomRight:Show()
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 24)
    MultiBarBottomRight:SetMovable(true)
    MultiBarBottomRight:SetUserPlaced(true)
    MultiBarBottomRight:SetScale(0.8)

    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetPoint("RIGHT", UIParent, "RIGHT", -16, 0)
    MultiBarRight:SetMovable(true)
    MultiBarRight:SetUserPlaced(true)

    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetPoint("RIGHT", MultiBarRight, "LEFT", -2, 0)
    MultiBarLeft:SetMovable(true)
    MultiBarLeft:SetUserPlaced(true)

    MainMenuBarLeftEndCap:Hide()
    MainMenuBarRightEndCap:Hide()
    MainMenuBarPageNumber:Hide()
    ActionBarUpButton:Hide()
    ActionBarDownButton:Hide()
    MainMenuBarTexture0:Hide()
    MainMenuBarTexture1:Hide()
    MainMenuBarTexture2:Hide()
    MainMenuBarTexture3:Hide()
    MainMenuMaxLevelBar0:Hide()
    MainMenuMaxLevelBar1:Hide()
    MainMenuMaxLevelBar2:Hide()
    MainMenuMaxLevelBar3:Hide()
    MainMenuBarMaxLevelBar:Hide()
    MainMenuBarOverlayFrame:Hide()
    SlidingActionBarTexture0:Hide()
    SlidingActionBarTexture0.Show = SlidingActionBarTexture0.Hide
    SlidingActionBarTexture1:Hide()
    SlidingActionBarTexture1.Show = SlidingActionBarTexture1.Hide
end

local ActionBarFrame = CreateFrame("Frame")
ActionBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionBarFrame:SetScript("OnEvent", UpdateActionButtons)


-- UPDATE ACTION BUTTONS

local function UpdateActionButtonAppearance()
    local function hideNormalTexture(button)
        if button then
            local PetButtonTexture1 = _G[button:GetName() .. "NormalTexture"]
            if PetButtonTexture1 then
                PetButtonTexture1:SetAlpha(0)
                PetButtonTexture1:SetTexture(nil)
            end
            local floatingBG = _G[button:GetName() .. "FloatingBG"]
            if floatingBG then
                floatingBG:SetAlpha(0)
                floatingBG:SetTexture(nil)
            end
        end
    end

    local function customizeButton(button)
        if button then
            if not button.customBorder then
                local backdrop = CreateFrame("Frame", nil, button, "BackdropTemplate")
                backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3, 3)
                backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
                backdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
                backdrop:SetBackdropBorderColor(unpack(N.RGB))
                backdrop:SetFrameStrata("HIGH")
                button.customBorder = backdrop
            end

            local icon = _G[button:GetName() .. "Icon"]
            if icon then
                icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
            end
        end
    end

    local function updateButtonFonts(button)
        if button then
            local macroName = _G[button:GetName() .. "Name"]
            if macroName then
                macroName:SetFont(F.TYPE, F.SIZE_SMALL, "OUTLINE")
                macroName:SetTextColor(unpack(W.RGB))
                macroName:SetAlpha(0.5)
            end
            local hotkey = _G[button:GetName() .. "HotKey"]
            if hotkey then
                hotkey:SetFont(F.TYPE, F.SIZE, "OUTLINE")
                hotkey:SetTextColor(unpack(W.RGB))
                hotkey:SetAlpha(0.75)
                hotkey.SetVertexColor = function() end
            end
        end
    end

    for i = 1, 12 do
        local buttons = {
            _G["ActionButton" .. i],
            _G["MultiBarBottomLeftButton" .. i],
            _G["MultiBarBottomRightButton" .. i],
            _G["MultiBarRightButton" .. i],
            _G["MultiBarLeftButton" .. i]
        }
        for _, button in ipairs(buttons) do
            hideNormalTexture(button)
            customizeButton(button)
            updateButtonFonts(button)
        end
    end
end

local ActionButtonFrame = CreateFrame("Frame")
ActionButtonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ActionButtonFrame:SetScript("OnEvent", UpdateActionButtonAppearance)