-- CREATE PET FRAME BACKDROP

local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
PetFrameBackdrop:SetBackdropBorderColor(unpack(N.RGB))
PetFrameBackdrop:SetFrameStrata("HIGH")
PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE PET FRAME

local function UpdatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)
	PetFrame:SetSize(PetFrameBackdrop:GetWidth(), PetFrameBackdrop:GetHeight())
    
    PetFrameTexture:Hide()

    PetPortrait:Hide()
	PetAttackModeTexture:SetTexture(nil)

    PetName:Hide()
	
	PetFrame:UnregisterEvent("UNIT_COMBAT")
	
	PetFrameHappiness:ClearAllPoints()
	PetFrameHappiness:SetPoint("RIGHT", PetFrameBackdrop, "LEFT", 0, 0)

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
    PetFrameHealthBar:SetStatusBarTexture(T.BAR)
    
    PetFrameManaBar:ClearAllPoints()
    PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
    PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-6)
    PetFrameManaBar:SetHeight(8)
    PetFrameManaBar:SetStatusBarTexture(T.BAR)
    
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