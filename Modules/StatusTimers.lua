-- UPDATE EXHAUSTION TIMERS

-- FUNCTION TO CREATE BACKDROP FOR EXHAUSTION TIMER
local function ExhaustionTimerBackdrop(ExhaustionTimer)
    
    if not _G[ExhaustionTimer.."CustomBackdrop"] then
        local ExhaustionTimerBackdrop = CreateFrame("Frame", ExhaustionTimer.."CustomBackdrop", _G[ExhaustionTimer.."StatusBar"], "BackdropTemplate")
        
        ExhaustionTimerBackdrop:SetPoint("TOPLEFT", _G[ExhaustionTimer.."StatusBar"], "TOPLEFT", -3, 3)
        ExhaustionTimerBackdrop:SetPoint("BOTTOMRIGHT", _G[ExhaustionTimer.."StatusBar"], "BOTTOMRIGHT", 3, -3)
        
        ExhaustionTimerBackdrop:SetBackdrop({
            edgeFile = T.EDGE,
            edgeSize = T.EDGE_SIZE
        })
        
        ExhaustionTimerBackdrop:SetBackdropBorderColor(unpack(N.RGB))
        ExhaustionTimerBackdrop:SetFrameStrata("HIGH")
    end
end

-- FUNCTION TO UPDATE EXHAUSTION TIMERS
local function ExhaustionTimerUpdate()
    
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local ExhaustionTimer = "MirrorTimer"..i
        
        _G[ExhaustionTimer.."Border"]:Hide()
        _G[ExhaustionTimer.."StatusBar"]:SetStatusBarTexture(T.BAR)
        _G[ExhaustionTimer.."Text"]:ClearAllPoints()
        _G[ExhaustionTimer.."Text"]:SetPoint("CENTER", _G[ExhaustionTimer.."StatusBar"], "CENTER", 0, 0)

        ExhaustionTimerBackdrop(ExhaustionTimer)
    end
end

-- CREATE FRAME AND REGISTER EVENTS
local ExhaustionTimerFrame = CreateFrame("Frame")
ExhaustionTimerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ExhaustionTimerFrame:RegisterEvent("MIRROR_TIMER_START")
ExhaustionTimerFrame:SetScript("OnEvent", ExhaustionTimerUpdate)