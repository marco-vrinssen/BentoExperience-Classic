-- CREATE TARGET TARGET BACKDROP

local ToTFrameBackdrop = CreateFrame("Button", nil, TargetFrameToT, "SecureUnitButtonTemplate, BackdropTemplate")
ToTFrameBackdrop:SetPoint("BOTTOMLEFT", TargetPortraitBackdrop, "BOTTOMRIGHT", 0, 0)
ToTFrameBackdrop:SetSize(64, 24)
ToTFrameBackdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
ToTFrameBackdrop:SetBackdropBorderColor(unpack(N.RGB))
ToTFrameBackdrop:SetFrameStrata("HIGH")
ToTFrameBackdrop:SetAttribute("unit", "targettarget")
ToTFrameBackdrop:RegisterForClicks("AnyUp")
ToTFrameBackdrop:SetAttribute("type1", "target")
ToTFrameBackdrop:SetAttribute("type2", "togglemenu")


-- UPDATE TARGET TARGET FRAME

local function ToTFrameUpdate()
	if GetCVar("ShowTargetOfTarget") ~= "1" then return end

	TargetFrameToT:ClearAllPoints()
	TargetFrameToT:SetPoint("CENTER", TargetFrameBackdrop, "CENTER", 0, 0)

	TargetFrameToTTextureFrame:Hide()
	TargetFrameToTTextureFrameName:SetParent(TargetFrameToT)
	TargetFrameToTTextureFrameName:ClearAllPoints()
	TargetFrameToTTextureFrameName:SetPoint("BOTTOMLEFT", ToTFrameBackdrop, "TOPLEFT", 2, 2)
	TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1, 1)
	TargetFrameToTTextureFrameName:SetFont(F.TYPE, 10, "OUTLINE")

	TargetFrameToTHealthBar:ClearAllPoints()
	TargetFrameToTHealthBar:SetPoint("TOP", ToTFrameBackdrop, "TOP", 0, -2)
	TargetFrameToTHealthBar:SetPoint("BOTTOMRIGHT", TargetFrameToTManaBar, "TOPRIGHT", 0, 0)
	TargetFrameToTHealthBar:SetWidth(ToTFrameBackdrop:GetWidth() - 6)
	TargetFrameToTHealthBar:SetStatusBarTexture(T.BAR)

	TargetFrameToTManaBar:ClearAllPoints()
	TargetFrameToTManaBar:SetPoint("BOTTOM", ToTFrameBackdrop, "BOTTOM", 0, 2)
	TargetFrameToTManaBar:SetHeight(8)
	TargetFrameToTManaBar:SetWidth(ToTFrameBackdrop:GetWidth() - 6)
	TargetFrameToTManaBar:SetStatusBarTexture(T.BAR)

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

local ToTFrameFrame = CreateFrame("Frame")
ToTFrameFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ToTFrameFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ToTFrameFrame:SetScript("OnEvent", ToTFrameUpdate)