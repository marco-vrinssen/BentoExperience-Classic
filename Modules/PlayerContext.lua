-- UPDATE PLAYER GROUP ELEMENTS

local function UpdatePlayerGroup()
    if PlayerFrameGroupIndicator then
        PlayerFrameGroupIndicator:SetAlpha(0)
        PlayerFrameGroupIndicator:Hide()
        
        if not PlayerFrameGroupIndicator.hooked then
            hooksecurefunc(PlayerFrameGroupIndicator, "Show", function(self)
                self:SetAlpha(0)
                self:Hide()
            end)
            PlayerFrameGroupIndicator.hooked = true
        end
    end

    local MultiGroupFrame = _G["MultiGroupFrame"]
    if MultiGroupFrame then
        MultiGroupFrame:SetTexture(nil)
        MultiGroupFrame:SetAlpha(0)
        MultiGroupFrame:Hide()
        
        if not MultiGroupFrame.hooked then
            hooksecurefunc(MultiGroupFrame, "Show", function(self)
                self:SetTexture(nil)
                self:SetAlpha(0)
                self:Hide()
            end)
            MultiGroupFrame.hooked = true
        end
    end
end

local PlayerGroupFrame = CreateFrame("Frame")
PlayerGroupFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerGroupFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
PlayerGroupFrame:RegisterEvent("PARTY_LEADER_CHANGED")
PlayerGroupFrame:SetScript("OnEvent", UpdatePlayerGroup)