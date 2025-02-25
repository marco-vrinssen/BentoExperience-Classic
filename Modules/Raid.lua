-- HIDE AURAS ON RAID FRAMES

local function HideAllAuras(frame)
    CompactUnitFrame_HideAllBuffs(frame)
    CompactUnitFrame_HideAllDebuffs(frame)
end

hooksecurefunc("CompactUnitFrame_UpdateAuras", HideAllAuras)