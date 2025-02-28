-- HIDE AURAS ON RAID FRAMES

local function HideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", HideAllAuras)

-- REPLACE RAID FRAME HEALTH BAR TEXTURE
local function ReplaceHealthBarTexture(frame)
    if frame and frame.healthBar then
        frame.healthBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
    ReplaceHealthBarTexture(frame)
end)

hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
    ReplaceHealthBarTexture(frame)
end)

hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame)
    ReplaceHealthBarTexture(frame)
end)

local textureFrame = CreateFrame("Frame")
textureFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
textureFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
textureFrame:SetScript("OnEvent", function(self, event)
    C_Timer.After(0.5, function()
        if CompactRaidFrameContainer then
            for i=1, 40 do
                local frame = _G["CompactRaidFrame"..i]
                if frame and frame:IsVisible() then
                    ReplaceHealthBarTexture(frame)
                end
                
                local groupFrame = _G["CompactRaidGroup1Member"..i]
                if groupFrame and groupFrame:IsVisible() then
                    ReplaceHealthBarTexture(groupFrame)
                end
            end
            
            if CompactRaidFrameContainer.flowFrames then
                for _, frame in pairs(CompactRaidFrameContainer.flowFrames) do
                    ReplaceHealthBarTexture(frame)
                end
            end
        end
    end)
end)


-- UPDATE GROUP FRAME CONFIG

local function UpdateGroupConfig()
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("raidFramesDisplayBorder", 0)
end

local GroupConfigFrame = CreateFrame("Frame")
GroupConfigFrame:RegisterEvent("PLAYER_LOGIN")
GroupConfigFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
GroupConfigFrame:SetScript("OnEvent", UpdateGroupConfig)