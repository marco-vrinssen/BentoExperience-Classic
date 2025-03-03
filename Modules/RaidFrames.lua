-- HIDE AURAS ON RAID FRAMES

local function hideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", hideAllAuras)


-- REPLACE RAID FRAME HEALTH BAR TEXTURE

local function replaceHealthBarTexture(frame)
    if frame and frame.healthBar then
        frame.healthBar:SetStatusBarTexture(BAR)
    end
end

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
    replaceHealthBarTexture(frame)
end)

hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
    replaceHealthBarTexture(frame)
end)

hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame)
    replaceHealthBarTexture(frame)
end)

local groupTextureEvents = CreateFrame("Frame")
groupTextureEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
groupTextureEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
groupTextureEvents:SetScript("OnEvent", function(self, event)
    C_Timer.After(0.5, function()
        if CompactRaidFrameContainer then
            for i = 1, 40 do
                local frame = _G["CompactRaidFrame"..i]
                if frame and frame:IsVisible() then
                    replaceHealthBarTexture(frame)
                end
                
                local groupFrame = _G["CompactRaidGroup1Member"..i]
                if groupFrame and groupFrame:IsVisible() then
                    replaceHealthBarTexture(groupFrame)
                end
            end
            
            if CompactRaidFrameContainer.flowFrames then
                for _, frame in pairs(CompactRaidFrameContainer.flowFrames) do
                    replaceHealthBarTexture(frame)
                end
            end
        end
    end)
end)


-- UPDATE GROUP FRAME CONFIG

local function updateGroupConfig()
    SetCVar("useCompactPartyFrames", 1)
    SetCVar("raidFramesDisplayClassColor", 1)
    SetCVar("raidFramesDisplayBorder", 0)
end

local groupConfigEvents = CreateFrame("Frame")
groupConfigEvents:RegisterEvent("PLAYER_LOGIN")
groupConfigEvents:RegisterEvent("GROUP_ROSTER_UPDATE")
groupConfigEvents:SetScript("OnEvent", updateGroupConfig)