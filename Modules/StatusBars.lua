-- UPDATE EXPERIENCE BAR

local XPBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
XPBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -3, 3)
XPBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 3, -3)
XPBarBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
XPBarBackdrop:SetBackdropBorderColor(unpack(GREY))
XPBarBackdrop:SetFrameLevel(MainMenuExpBar:GetFrameLevel() + 2)

local function HideXPTextures()
    for i = 0, 3 do
        local texture = _G["MainMenuXPBarTexture" .. i]
        if texture then
            texture:Hide()
            texture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end

local function UpdateXPBar()
    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        MainMenuExpBar:Hide()
    else
        MainMenuExpBar:Show()
    end

    HideXPTextures()

    MainMenuExpBar:SetWidth(120)
    MainMenuExpBar:SetHeight(12)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
    MainMenuExpBar:SetStatusBarTexture(BAR)
    MainMenuExpBar:SetStatusBarColor(unpack(PURPLE))
    
    MainMenuExpBar:EnableMouse(true)
end

local ExperienceBarFrame = CreateFrame("Frame")
ExperienceBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ExperienceBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
ExperienceBarFrame:RegisterEvent("PLAYER_XP_UPDATE")
ExperienceBarFrame:RegisterEvent("UPDATE_EXHAUSTION")
ExperienceBarFrame:SetScript("OnEvent", UpdateXPBar)


-- EXPERIENCE TOOLTIP FUNCTIONALITY

local function XPTooltip()
    local CurrentExperience, MaxExperience = UnitXP("player"), UnitXPMax("player")
    local RestedExperience = GetXPExhaustion() or 0

    local ExpTooltipContent = string.format(
        "%sExperience%s\n" ..
        "%sProgress:%s %s%d%%%s\n" ..
        "%sRested:%s %s%d%%%s\n" ..
        "%sCurrent:%s %s%d%s\n" ..
        "%sMissing:%s %s%d%s\n" ..
        "%sTotal:%s %s%d%s",
        PURPLE_LUA, "|r",
        YELLOW_LUA, "|r", WHITE_LUA, math.floor((CurrentExperience / MaxExperience) * 100), "|r",
        YELLOW_LUA, "|r", WHITE_LUA, math.floor((RestedExperience / MaxExperience) * 100), "|r",
        YELLOW_LUA, "|r", WHITE_LUA, CurrentExperience, "|r",
        YELLOW_LUA, "|r", WHITE_LUA, MaxExperience - CurrentExperience, "|r",
        YELLOW_LUA, "|r", WHITE_LUA, MaxExperience, "|r"
    )

    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    GameTooltip:SetText(ExpTooltipContent, nil, nil, nil, nil, true)
    GameTooltip:Show()
end

MainMenuExpBar:HookScript("OnEnter", XPTooltip)
MainMenuExpBar:HookScript("OnLeave", function() GameTooltip:Hide() end)


-- REPUTATION BAR

local RepBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
RepBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -3, 3)
RepBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 3, -3)
RepBackdrop:SetBackdrop({edgeFile = EDGE, edgeSize = MEDIUM})
RepBackdrop:SetBackdropBorderColor(unpack(GREY))
RepBackdrop:SetFrameLevel(ReputationWatchBar.StatusBar:GetFrameLevel() + 2)

local function HideRepTextures()
    local textureNames = {
        "XPBarTexture0", "XPBarTexture1", "XPBarTexture2", "XPBarTexture3",
        "WatchBarTexture0", "WatchBarTexture1", "WatchBarTexture2", "WatchBarTexture3"
    }
    for _, name in ipairs(textureNames) do
        local texture = ReputationWatchBar.StatusBar[name]
        if texture then
            texture:Hide()
            texture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end

local function UpdateRepBar()
    if not GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:Hide()
        return
    end

    HideRepTextures()

    ReputationWatchBar.StatusBar:SetWidth(120)
    ReputationWatchBar.StatusBar:SetHeight(12)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -32)
    ReputationWatchBar.StatusBar:SetStatusBarTexture(BAR)
    ReputationWatchBar.StatusBar:SetStatusBarColor(unpack(LIGHTBLUE))
    
    ReputationWatchBar.StatusBar:EnableMouse(true)
    ReputationWatchBar.StatusBar:Show()
end

local RepBarEvents = CreateFrame("Frame")
RepBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
RepBarEvents:RegisterEvent("UPDATE_FACTION")
RepBarEvents:SetScript("OnEvent", UpdateRepBar)


-- REPUTATION TOOLTIP

local function RepTooltip()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        local progress = value - min
        local total = max - min
        local progressPercent = math.floor((progress / total) * 100)

        local RepTooltipContent = string.format(
            "%sReputation%s\n" ..
            "%sFaction:%s %s%s%s\n" ..
            "%sStanding:%s %s%s%s\n" ..
            "%sProgress:%s %s%d%%%s\n" ..
            "%sCurrent:%s %s%d%s\n" ..
            "%sTotal:%s %s%d%s",
            LIGHTBLUE_LUA, "|r",
            YELLOW_LUA, "|r", WHITE_LUA, name, "|r",
            YELLOW_LUA, "|r", WHITE_LUA, _G["FACTION_STANDING_LABEL"..standing], "|r",
            YELLOW_LUA, "|r", WHITE_LUA, progressPercent, "|r",
            YELLOW_LUA, "|r", WHITE_LUA, progress, "|r",
            YELLOW_LUA, "|r", WHITE_LUA, total, "|r"
        )

        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:SetText(RepTooltipContent, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

ReputationWatchBar.StatusBar:HookScript("OnEnter", RepTooltip)
ReputationWatchBar.StatusBar:HookScript("OnLeave", function() GameTooltip:Hide() end)


-- CREATE EXHAUSTION TIMER BACKDROP

local function ExhTimerBackdrop(ExhaustionTimer)
    
    if not _G[ExhaustionTimer.."CustomBackdrop"] then
        local ExhTimerBackdrop = CreateFrame("Frame", ExhaustionTimer.."CustomBackdrop", _G[ExhaustionTimer.."StatusBar"], "BackdropTemplate")
        ExhTimerBackdrop:SetPoint("TOPLEFT", _G[ExhaustionTimer.."StatusBar"], "TOPLEFT", -3, 3)
        ExhTimerBackdrop:SetPoint("BOTTOMRIGHT", _G[ExhaustionTimer.."StatusBar"], "BOTTOMRIGHT", 3, -3)
        ExhTimerBackdrop:SetBackdrop({ edgeFile = EDGE, edgeSize = MEDIUM})
        ExhTimerBackdrop:SetBackdropBorderColor(unpack(GREY))
        ExhTimerBackdrop:SetFrameLevel(_G[ExhaustionTimer.."StatusBar"]:GetFrameLevel() + 2)
    end
end


-- UPDATE EXHAUSTION TIMERS

local function UpdateExhTimer()
    
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local ExhaustionTimer = "MirrorTimer"..i
        
        _G[ExhaustionTimer.."Border"]:Hide()
        _G[ExhaustionTimer.."StatusBar"]:SetStatusBarTexture(BAR)
        _G[ExhaustionTimer.."Text"]:ClearAllPoints()
        _G[ExhaustionTimer.."Text"]:SetPoint("CENTER", _G[ExhaustionTimer.."StatusBar"], "CENTER", 0, 0)

        ExhTimerBackdrop(ExhaustionTimer)
    end
end

local ExhTimerEvents = CreateFrame("Frame")
ExhTimerEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ExhTimerEvents:RegisterEvent("MIRROR_TIMER_START")
ExhTimerEvents:SetScript("OnEvent", UpdateExhTimer)