-- CREATE PET FRAME BACKDROP

local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
PetFrameBackdrop:SetBackdropBorderColor(unpack(GREY))
PetFrameBackdrop:SetFrameLevel(PetFrame:GetFrameLevel() + 2)
PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE PET FRAME

local function UpdatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)
	PetFrame:SetSize(PetFrameBackdrop:GetWidth(), PetFrameBackdrop:GetHeight())
    PetFrame:UnregisterEvent("UNIT_COMBAT")
	PetAttackModeTexture:SetTexture(nil)
    PetFrameTexture:Hide()
   
    PetPortrait:Hide()

    PetName:ClearAllPoints()
    PetName:SetPoint("BOTTOMRIGHT", PetFrameBackdrop, "TOPRIGHT", 0, 2)
    PetName:SetFont(FONT, SMALL, "OUTLINE")
    PetName:SetTextColor(unpack(WHITE))

	for i = 1, MAX_TARGET_BUFFS do
		local PetBuff = _G["PetFrameBuff" .. i]
		if PetBuff then
			PetBuff:SetAlpha(0)
		end
	end
	
	for i = 1, MAX_TARGET_DEBUFFS do
		local PetDebuff = _G["PetFrameDebuff" .. i]
		if PetDebuff then
			PetDebuff:SetAlpha(0)
		end
	end
end

local PetFrameFrame = CreateFrame("Frame")
PetFrameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PetFrameFrame:RegisterEvent("UNIT_PET")
PetFrameFrame:SetScript("OnEvent", UpdatePetFrame)


-- UPDATE PET RESOURCES

local function UpdatePetResources()
    PetFrameHealthBar:ClearAllPoints()
    PetFrameHealthBar:SetPoint("TOP", PetFrameBackdrop, "TOP", 0, -2)
    PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
    PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameHealthBar:SetStatusBarTexture(BAR)
    
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
    PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetStatusBarTexture(BAR)
    
    PetFrameHealthBarText:SetAlpha(0)
    PetFrameHealthBarTextLeft:SetAlpha(0)
    PetFrameHealthBarTextRight:SetAlpha(0)

    PetFrameManaBarText:SetAlpha(0)
    PetFrameManaBarTextLeft:SetAlpha(0)
    PetFrameManaBarTextRight:SetAlpha(0)
end

local PetResourceFrame = CreateFrame("Frame")
PetResourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PetResourceFrame:RegisterEvent("UNIT_PET")
PetResourceFrame:RegisterEvent("UNIT_POWER_UPDATE")
PetResourceFrame:SetScript("OnEvent", function(self, event, unit)
    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_PET" or 
       (event == "UNIT_POWER_UPDATE" and unit == "pet") then
        UpdatePetResources()
    end
end)


-- CREATE PET HAPPINESS BACKDROP

local PetHappinessBackdrop = CreateFrame("Frame", nil, PetFrame, "BackdropTemplate")
PetHappinessBackdrop:SetSize(24, 24)
PetHappinessBackdrop:SetPoint("RIGHT", PetFrameBackdrop, "LEFT", 0, 0)
PetHappinessBackdrop:SetBackdrop({
    bgFile = "Interface\\Icons\\ability_hunter_beasttraining",
    edgeFile = EDGE, edgeSize = MEDIUM,
    insets = {left = 2, right = 2, top = 2, bottom = 2}
})
PetHappinessBackdrop:SetBackdropBorderColor(unpack(GREY))
PetHappinessBackdrop:SetFrameLevel(PetFrame:GetFrameLevel() + 2)


-- UPDATE PET HAPPINESS

local function UpdatePetHappiness()
    PetFrameHappiness:Hide()
    PetFrameHappinessTexture:Hide()

    local happiness = GetPetHappiness()
    if happiness and happiness < 3 then
        PetHappinessBackdrop:Show()
    else
        PetHappinessBackdrop:Hide()
    end
end

local PetHappinessFrame = CreateFrame("Frame")
PetHappinessFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PetHappinessFrame:RegisterEvent("UNIT_HAPPINESS")
PetHappinessFrame:RegisterEvent("UNIT_PET")
PetHappinessFrame:SetScript("OnEvent", function(self, event, unit)
    if unit == "pet" or event == "PLAYER_ENTERING_WORLD" then
        UpdatePetHappiness()
    end
end)