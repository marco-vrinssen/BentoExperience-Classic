-- UPDATE TARGET CASTBAR

local TargetSpellBarBackdrop = CreateFrame("Frame", nil, TargetFrameSpellBar, "BackdropTemplate")
TargetSpellBarBackdrop:SetPoint("TOP", TargetFrameBackdrop, "BOTTOM", 0, 0)
TargetSpellBarBackdrop:SetSize(TargetFrameBackdrop:GetWidth(), 24)
TargetSpellBarBackdrop:SetBackdrop({ edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE })
TargetSpellBarBackdrop:SetBackdropBorderColor(unpack(N.RGB))
TargetSpellBarBackdrop:SetFrameStrata("HIGH")

local function TargetSpellBarUpdate()
	TargetFrameSpellBar:ClearAllPoints()
	TargetFrameSpellBar:SetPoint("TOPLEFT", TargetSpellBarBackdrop, "TOPLEFT", 3, -2)
	TargetFrameSpellBar:SetPoint("BOTTOMRIGHT", TargetSpellBarBackdrop, "BOTTOMRIGHT", -3, 2)
	TargetFrameSpellBar:SetStatusBarTexture(T.BAR)
	TargetFrameSpellBar:SetStatusBarColor(unpack(Y.RGB))
	TargetFrameSpellBar.Border:SetTexture(nil)
	TargetFrameSpellBar.Flash:SetTexture(nil)
	TargetFrameSpellBar.Spark:SetTexture(nil)
	TargetFrameSpellBar.Icon:SetSize(TargetSpellBarBackdrop:GetHeight() - 4, TargetSpellBarBackdrop:GetHeight() - 4)
	TargetFrameSpellBar.Text:ClearAllPoints()
	TargetFrameSpellBar.Text:SetPoint("CENTER", TargetSpellBarBackdrop, "CENTER", 0, 0)
	TargetFrameSpellBar.Text:SetFont(F.TYPE, 10, "OUTLINE")
end

TargetFrameSpellBar:HookScript("OnShow", TargetSpellBarUpdate)
TargetFrameSpellBar:HookScript("OnUpdate", TargetSpellBarUpdate)

local TargetSpellBarFrame = CreateFrame("Frame")
TargetSpellBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetSpellBarFrame:SetScript("OnEvent", TargetSpellBarUpdate)