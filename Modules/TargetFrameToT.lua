-- ToT frame update section
local ToTFrameBackdrop = CreateFrame("Button", nil, TargetFrameToT, "SecureUnitButtonTemplate, BackdropTemplate")
ToTFrameBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
ToTFrameBackdrop:SetSize(64, 24)
ToTFrameBackdrop:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = true, edgeSize = 12 })
ToTFrameBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
ToTFrameBackdrop:SetFrameStrata("HIGH")
ToTFrameBackdrop:SetAttribute("unit", "targettarget")
ToTFrameBackdrop:RegisterForClicks("AnyUp")
ToTFrameBackdrop:SetAttribute("type1", "target")
ToTFrameBackdrop:SetAttribute("type2", "togglemenu")

local function ToTFrameUpdate()
	-- Check if the target-of-target cvar is active
	if GetCVar("ShowTargetOfTarget") ~= "1" then return end

	TargetFrameToT:ClearAllPoints()
	TargetFrameToT:SetPoint("CENTER", TargetFrameBackdrop, "CENTER", 0, 0)

	TargetFrameToTTextureFrame:Hide()
	TargetFrameToTTextureFrameName:SetParent(TargetFrameToT)
	TargetFrameToTTextureFrameName:ClearAllPoints()
	TargetFrameToTTextureFrameName:SetPoint("BOTTOMLEFT", ToTFrameBackdrop, "TOPLEFT", 2, 2)
	TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1, 1)
	TargetFrameToTTextureFrameName:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")

	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("BOTTOM", TargetFrameToTManaBar, "TOP", 0, 0)
	TargetFrameToTHealthBar:SetPoint("TOP", ToTFrameBackdrop, "TOP", 0, -2)
	TargetFrameToTHealthBar:SetWidth(ToTFrameBackdrop:GetWidth() - 4)
	TargetFrameToTHealthBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("BOTTOM", ToTFrameBackdrop, "BOTTOM", 0, 2)
	TargetFrameToTManaBar:SetHeight(8)
	TargetFrameToTManaBar:SetWidth(ToTFrameBackdrop:GetWidth() - 4)
	TargetFrameToTManaBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")

	TargetFrameToTBackground:Hide()
	TargetFrameToTTextureFrameTexture:Hide()
	TargetFrameToTPortrait:Hide()

	for i = 1, MAX_TARGET_BUFFS do
		local ToTBuff = _G["TargetFrameToTBuff" .. i]
		if ToTBuff then
			ToTBuff:SetAlpha(0)
		end
	end

	for i = 1, MAX_TARGET_DEBUFFS do
		local ToTDebuff = _G["TargetFrameToTDebuff" .. i]
		if ToTDebuff then
			ToTDebuff:SetAlpha(0)
		end
	end
end

local ToTFrameEvents = CreateFrame("Frame")
ToTFrameEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTFrameEvents:RegisterEvent("PLAYER_TARGET_CHANGED")
ToTFrameEvents:SetScript("OnEvent", ToTFrameUpdate)