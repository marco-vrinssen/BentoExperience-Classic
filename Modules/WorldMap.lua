-- UPDATE WORLD MAP APPEARANCE

local function UpdateWorldMapFrame()
    WorldMapFrame:ClearAllPoints()
    WorldMapFrame:SetScale(0.75)
    WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    WorldMapFrame.BlackoutFrame.Show = function()
        WorldMapFrame.BlackoutFrame:Hide()
    end
    WorldMapFrame.ScrollContainer.GetCursorPosition = function()
        local MapWidth, MapHeight = MapCanvasScrollControllerMixin.GetCursorPosition()
        return MapWidth / 0.75, MapHeight / 0.75
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
        local TargetAlpha = IsPlayerMoving() and 0.25 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), TargetAlpha)
    end
end

local MapFadeFrame = CreateFrame("Frame")
MapFadeFrame:RegisterEvent("PLAYER_STARTED_MOVING")
MapFadeFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
MapFadeFrame:SetScript("OnEvent", FadeOutMap)