-- UPDATE EXHAUSTION TIMERS

local function ExhaustionTimerBackdrop(ExhaustionTimer)
    if not _G[ExhaustionTimer.."CustomBackdrop"] then
        local ExhaustionTimerBackdrop = CreateFrame("Frame", ExhaustionTimer.."CustomBackdrop", _G[ExhaustionTimer.."StatusBar"], "BackdropTemplate")
        ExhaustionTimerBackdrop:SetPoint("TOPLEFT", _G[ExhaustionTimer.."StatusBar"], "TOPLEFT", -3, 2)
        ExhaustionTimerBackdrop:SetPoint("BOTTOMRIGHT", _G[ExhaustionTimer.."StatusBar"], "BOTTOMRIGHT", 3, -2)
        ExhaustionTimerBackdrop:SetBackdrop({
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 12
        })
        ExhaustionTimerBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
        ExhaustionTimerBackdrop:SetFrameStrata("HIGH")
    end
end

local function ExhaustionTimerUpdate()
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local ExhaustionTimer = "MirrorTimer"..i
        _G[ExhaustionTimer.."Border"]:Hide()
        _G[ExhaustionTimer.."StatusBar"]:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        _G[ExhaustionTimer.."Text"]:ClearAllPoints()
        _G[ExhaustionTimer.."Text"]:SetPoint("CENTER", _G[ExhaustionTimer.."StatusBar"], "CENTER", 0, 0)

        ExhaustionTimerBackdrop(ExhaustionTimer)
    end
end

local ExhaustionTimerEvents = CreateFrame("Frame")
ExhaustionTimerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ExhaustionTimerEvents:RegisterEvent("MIRROR_TIMER_START")
ExhaustionTimerEvents:SetScript("OnEvent", ExhaustionTimerUpdate)