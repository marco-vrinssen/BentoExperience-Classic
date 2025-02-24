-- Setup backdrop for the pet frame
local PetFrameBackdrop = CreateFrame("Button", nil, PetFrame, "SecureUnitButtonTemplate, BackdropTemplate")
PetFrameBackdrop:SetPoint("BOTTOMRIGHT", PlayerPortraitBackdrop, "BOTTOMLEFT", 0, 0)
PetFrameBackdrop:SetSize(64, 24)
PetFrameBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12})
PetFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
PetFrameBackdrop:SetFrameStrata("HIGH")
PetFrameBackdrop:SetAttribute("unit", "pet")
PetFrameBackdrop:RegisterForClicks("AnyUp")
PetFrameBackdrop:SetAttribute("type1", "target")
PetFrameBackdrop:SetAttribute("type2", "togglemenu")


-- Update pet frame properties
local function UpdatePetFrame()
	PetFrame:ClearAllPoints()
	PetFrame:SetPoint("CENTER", PetFrameBackdrop, "CENTER", 0, 0)
	PetFrame:SetSize(PetFrameBackdrop:GetWidth(), PetFrameBackdrop:GetHeight())
    
    PetFrameTexture:Hide()

    PetPortrait:Hide()
	PetAttackModeTexture:SetTexture(nil)

    PetName:Hide()
	
	PetFrameHealthBar:ClearAllPoints()
	PetFrameHealthBar:SetPoint("BOTTOM", PetFrameManaBar, "TOP", 0, 0)
	PetFrameHealthBar:SetPoint("TOP", PetFrameBackdrop, "TOP", 0, -2)
	PetFrameHealthBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
	PetFrameHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
	
	PetFrameManaBar:ClearAllPoints()
	PetFrameManaBar:SetPoint("BOTTOM", PetFrameBackdrop, "BOTTOM", 0, 2)
	PetFrameManaBar:SetHeight(8)
	PetFrameManaBar:SetWidth(PetFrameBackdrop:GetWidth()-4)
	PetFrameManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
	
	PetFrameHealthBarText:SetAlpha(0)
	PetFrameHealthBarTextLeft:SetAlpha(0)
	PetFrameHealthBarTextRight:SetAlpha(0)
	PetFrameManaBarText:SetAlpha(0)
	PetFrameManaBarTextLeft:SetAlpha(0)
	PetFrameManaBarTextRight:SetAlpha(0)
	

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

-- Setup pet frame event listener
local PetFrameEvents = CreateFrame("Frame")
PetFrameEvents:RegisterEvent("UNIT_PET")
PetFrameEvents:SetScript("OnEvent", UpdatePetFrame)