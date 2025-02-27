-- UPDATE TARGET CONFIGURATION

local function TargetConfigUpdate()
	SetCVar("showTargetCastbar", 1)
	TARGET_FRAME_BUFFS_ON_TOP = true
end

local TargetConfigFrame = CreateFrame("Frame")
TargetConfigFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TargetConfigFrame:SetScript("OnEvent", TargetConfigUpdate)