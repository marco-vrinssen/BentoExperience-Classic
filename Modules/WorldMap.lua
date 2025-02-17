-- Function to update the world map frame
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

-- Hook the world map frame update function
WorldMapFrame:HookScript("OnUpdate", UpdateWorldMapFrame)
WorldMapFrame:HookScript("OnShow", function()
    UIFrameFadeIn(WorldMapFrame, 0.1, 0, 1)
    UpdateWorldMapFrame()
end)

-- Function to fade out the world map frame when the player starts moving
local function FadeOutMap()
    if WorldMapFrame:IsShown() then
        local targetAlpha = IsPlayerMoving() and 0.25 or 1
        UIFrameFadeOut(WorldMapFrame, 0.1, WorldMapFrame:GetAlpha(), targetAlpha)
    end
end

-- Register events to fade out the world map frame when the player starts or stops moving
local fadeOutEvents = CreateFrame("Frame")
fadeOutEvents:RegisterEvent("PLAYER_STARTED_MOVING")
fadeOutEvents:RegisterEvent("PLAYER_STOPPED_MOVING")
fadeOutEvents:SetScript("OnEvent", FadeOutMap)