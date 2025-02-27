local function UpdateGroupConfig()
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("raidFramesDisplayBorder", 0)
end

local GroupConfigFrame = CreateFrame("Frame")
GroupConfigFrame:RegisterEvent("PLAYER_LOGIN")
GroupConfigFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
GroupConfigFrame:SetScript("OnEvent", UpdateGroupConfig)