-- UPDATE WORLD MAP

local function UpdateWorldMapFrame()
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetScale(0.75)
    WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    WorldMapFrame.BlackoutFrame.Show = function()
        WorldMapFrame.BlackoutFrame:Hide()
    end
    WorldMapFrame.ScrollContainer.GetCursorPosition = function()
        local width, height = MapCanvasScrollControllerMixin.GetCursorPosition()
        return width / 0.75, height / 0.75
    end
end

WorldMapFrame:HookScript("OnUpdate", UpdateWorldMapFrame)
WorldMapFrame:HookScript("OnShow", function()
    UIFrameFadeIn(WorldMapFrame, 0.1, 0, 1)
    UpdateWorldMapFrame()
end)




-- ENABLE WORLD MAP FADE WHEN MOVING

local function FadeOutMap()
    if WorldMapFrame:IsShown() then
        local targetAlpha = IsPlayerMoving() and 0.25 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), targetAlpha)
    end
end

local fadeOutEvents = CreateFrame("Frame")
fadeOutEvents:RegisterEvent("PLAYER_STARTED_MOVING")
fadeOutEvents:RegisterEvent("PLAYER_STOPPED_MOVING")
fadeOutEvents:SetScript("OnEvent", FadeOutMap)