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

-- Hook into health color updates which happen frequently on frames
hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
    ReplaceHealthBarTexture(frame)
end)

-- Apply to frames when they get their health
hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
    ReplaceHealthBarTexture(frame)
end)

-- Direct hook for frame initialization
hooksecurefunc("DefaultCompactUnitFrameSetup", function(frame)
    ReplaceHealthBarTexture(frame)
end)

-- Create a frame to apply textures when UI loads and after each loading screen
local textureFrame = CreateFrame("Frame")
textureFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
textureFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
textureFrame:SetScript("OnEvent", function(self, event)
    -- Use C_Timer to delay execution slightly to ensure frames exist
    C_Timer.After(0.5, function()
        -- Apply to all raid and party frames
        if CompactRaidFrameContainer then
            -- Classic method to access raid frames
            for i=1, 40 do
                local frame = _G["CompactRaidFrame"..i]
                if frame and frame:IsVisible() then
                    ReplaceHealthBarTexture(frame)
                end
                
                -- Also check for group frames
                local groupFrame = _G["CompactRaidGroup1Member"..i]
                if groupFrame and groupFrame:IsVisible() then
                    ReplaceHealthBarTexture(groupFrame)
                end
            end
            
            -- Try to get all compact raid frames through container if possible
            if CompactRaidFrameContainer.flowFrames then
                for _, frame in pairs(CompactRaidFrameContainer.flowFrames) do
                    ReplaceHealthBarTexture(frame)
                end
            end
        end
    end)
end)