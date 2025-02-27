-- HIDE DEFAULT FRAMERATE LABEL

local function EnforceHideFramerateLabel()
    FramerateLabel:Hide()
end

FramerateLabel:HookScript("OnShow", EnforceHideFramerateLabel)


-- SETUP FRAMERATE DISPLAY

local function FramerateUpdate()
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", UIParent, "TOP", 0, -16)
    FramerateText:SetFont(F.TYPE, 12, "OUTLINE")
end

local FramerateFrame = CreateFrame("Frame")
FramerateFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
FramerateFrame:SetScript("OnEvent", FramerateUpdate)


-- CREATE LATENCY DISPLAY

local LatencyFrame = CreateFrame("Frame", "BentoLatencyFrame", UIParent)
local LatencyText = LatencyFrame:CreateFontString(nil, "OVERLAY")
LatencyText:SetFont(F.TYPE, 16, "OUTLINE")
LatencyText:SetPoint("TOP", FramerateText, "BOTTOM", 0, -8)


-- UPDATE LATENCY INFORMATION

local function UpdateLatency()
    local homeLatency, worldLatency = select(3, GetNetStats())
    LatencyText:SetText(homeLatency.."ms / "..worldLatency.."ms")
end

LatencyFrame:SetScript("OnShow", UpdateLatency)


-- LINK FRAMERATE AND LATENCY VISIBILITY

local function UpdateLatencyFrameVisibility()
    if FramerateText:IsShown() then
        LatencyFrame:Show()
    else
        LatencyFrame:Hide()
    end
end

FramerateText:HookScript("OnShow", UpdateLatencyFrameVisibility)
FramerateText:HookScript("OnHide", UpdateLatencyFrameVisibility)


-- INITIALIZE ON PLAYER LOGIN

LatencyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
LatencyFrame:SetScript("OnEvent", UpdateLatencyFrameVisibility)


-- PERIODIC LATENCY UPDATES

local updateTimer = 0
LatencyFrame:SetScript("OnUpdate", function(self, elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer >= 1 then -- Update every second
        updateTimer = 0
        if LatencyFrame:IsShown() then
            UpdateLatency()
        end
    end
end)