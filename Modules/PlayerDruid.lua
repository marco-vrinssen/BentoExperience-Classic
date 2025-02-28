-- ENABLE DRUID MANA BAR

local _, ClassIdentifier = UnitClass("player")

if ClassIdentifier == "DRUID" then

    local DruidManaBarBackdrop = CreateFrame("Frame", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBarBackdrop:SetPoint("TOP", PlayerFrameBackdrop, "BOTTOM", 0, 0)
    DruidManaBarBackdrop:SetSize(PlayerFrameBackdrop:GetWidth() - 2, 16)
    DruidManaBarBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM, })
    DruidManaBarBackdrop:SetBackdropBorderColor(unpack(GREY))

    local DruidManaBar = CreateFrame("StatusBar", nil, PlayerFrame, "BackdropTemplate")
    DruidManaBar:SetSize(DruidManaBarBackdrop:GetWidth()-4, DruidManaBarBackdrop:GetHeight()-4)
    DruidManaBar:SetPoint("CENTER", DruidManaBarBackdrop, "CENTER", 0, 0)
    DruidManaBar:SetStatusBarTexture(BAR)
    DruidManaBar:SetStatusBarColor(unpack(BLUE))
    DruidManaBar:SetMinMaxValues(0, 1)

    DruidManaBarBackdrop:SetFrameLevel(DruidManaBar:GetFrameLevel() + 1)

    local DruidManaText = DruidManaBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    DruidManaText:SetPoint("CENTER", DruidManaBar, "CENTER", 0, 0)
    DruidManaText:SetTextColor(1, 1, 1)
    DruidManaText:SetFont(GameFontNormal:GetFont(), SMALL, "OUTLINE")

    local function DruidManaBarUpdate()
        local PlayerPowerType, PowerToken = UnitPowerType("player")
        local PlayerForm = GetShapeshiftFormID()
    
        if PlayerForm and PowerToken ~= "MANA" then
            local PlayerMana = UnitPower("player", Enum.PowerType.Mana)
            local PlayerMaxMana = UnitPowerMax("player", Enum.PowerType.Mana)
            DruidManaBar:SetValue(PlayerMana / PlayerMaxMana)
            DruidManaText:SetText(PlayerMana .. " / " .. PlayerMaxMana)
            DruidManaBar:Show()
            DruidManaBarBackdrop:Show()
        else
            DruidManaBar:Hide()
            DruidManaBarBackdrop:Hide()
        end
    end

    local DruidManaBarFrame = CreateFrame("Frame")
    DruidManaBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    DruidManaBarFrame:RegisterEvent("UNIT_POWER_UPDATE")
    DruidManaBarFrame:RegisterEvent("UNIT_DISPLAYPOWER")
    DruidManaBarFrame:SetScript("OnEvent", DruidManaBarUpdate)
end