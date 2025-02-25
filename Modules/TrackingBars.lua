-- GENERATE EXPERIENCE BAR BACKDROP

local XPBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
XPBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -3, 3)
XPBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 3, -3)
XPBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
XPBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
XPBarBackdrop:SetFrameStrata("HIGH")




-- UPDATE EXPERIENCE BAR

local function UpdateExperienceBar()
    if UnitLevel("player") == MAX_PLAYER_LEVEL then
        MainMenuExpBar:Hide()
        return
    end

    MainMenuXPBarTexture0:Hide()
    MainMenuXPBarTexture1:Hide()
    MainMenuXPBarTexture2:Hide()
    MainMenuXPBarTexture3:Hide()

    MainMenuExpBar:SetWidth(120)
    MainMenuExpBar:SetHeight(12)
    MainMenuExpBar:ClearAllPoints()
    MainMenuExpBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
    MainMenuExpBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    MainMenuExpBar:SetStatusBarColor(0.643, 0.231, 0.918)
    
    MainMenuExpBar:EnableMouse(true)
    MainMenuExpBar:Show()
end




-- GENERATE AND ENABLE EXPERIENCE BAR TOOLTIP

local function ExpTooltip()
    local CurrentExperience, MaxExperience = UnitXP("player"), UnitXPMax("player")
    local RestedExperience = GetXPExhaustion() or 0

    local ExpTooltipContent = string.format(
        "|cFFA43BEAExperience|r\n" ..
        "|cFFFBD134Progress:|r |cFFFFFFFF%d%%|r\n" ..
        "|cFFFBD134Rested:|r |cFFFFFFFF%d%%|r\n" ..
        "|cFFFBD134Current:|r |cFFFFFFFF%d|r\n" ..
        "|cFFFBD134Missing:|r |cFFFFFFFF%d|r\n" ..
        "|cFFFBD134Total:|r |cFFFFFFFF%d|r",
        math.floor((CurrentExperience / MaxExperience) * 100),
        math.floor((RestedExperience / MaxExperience) * 100),
        CurrentExperience,
        MaxExperience - CurrentExperience,
        MaxExperience
    )

    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    GameTooltip:SetText(ExpTooltipContent, nil, nil, nil, nil, true)
    GameTooltip:Show()
end

local ExperienceBarEvents = CreateFrame("Frame")
ExperienceBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ExperienceBarEvents:RegisterEvent("PLAYER_LEVEL_UP")
ExperienceBarEvents:RegisterEvent("PLAYER_XP_UPDATE")
ExperienceBarEvents:RegisterEvent("UPDATE_EXHAUSTION")
ExperienceBarEvents:SetScript("OnEvent", UpdateExperienceBar)

MainMenuExpBar:HookScript("OnEnter", ExpTooltip)
MainMenuExpBar:HookScript("OnLeave", function() GameTooltip:Hide() end)




-- GENERATE REPUTATION BAR BACKDROP
local RepBarBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
RepBarBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -3, 3)
RepBarBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 3, -3)
RepBarBackdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
RepBarBackdrop:SetBackdropBorderColor(0.5, 0.5, 0.5)
RepBarBackdrop:SetFrameStrata("HIGH")




-- UPDATE REPUTATION BAR

local function UpdateReputationBar()
    if not GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:Hide()
        return
    end
    
    ReputationWatchBar.StatusBar.WatchBarTexture0:Hide() 
    ReputationWatchBar.StatusBar.WatchBarTexture1:Hide() 
    ReputationWatchBar.StatusBar.WatchBarTexture2:Hide() 
    ReputationWatchBar.StatusBar.WatchBarTexture3:Hide() 

    ReputationWatchBar.StatusBar:SetWidth(120)
    ReputationWatchBar.StatusBar:SetHeight(12)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -32)
    ReputationWatchBar.StatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
    ReputationWatchBar.StatusBar:SetStatusBarColor(0.157, 0.443, 0.851)
    
    ReputationWatchBar.StatusBar:EnableMouse(true)
    ReputationWatchBar.StatusBar:Show()
end




-- GENERATE AND ENABLE REPUTATION BAR TOOLTIP

local function RepTooltip()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        local progress = value - min
        local total = max - min
        local progressPercent = math.floor((progress / total) * 100)

        local RepTooltipContent = string.format(
            "|cFF2871D9Reputation|r\n" ..
            "|cFFFBD134Faction:|r |cFFFFFFFF%s|r\n" ..
            "|cFFFBD134Standing:|r |cFFFFFFFF%s|r\n" ..
            "|cFFFBD134Progress:|r |cFFFFFFFF%d%%|r\n" ..
            "|cFFFBD134Current:|r |cFFFFFFFF%d|r\n" ..
            "|cFFFBD134Total:|r |cFFFFFFFF%d|r",
            name,
            _G["FACTION_STANDING_LABEL"..standing],
            progressPercent,
            progress,
            total
        )

        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:SetText(RepTooltipContent, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

local ReputationBarEvents = CreateFrame("Frame")
ReputationBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
ReputationBarEvents:RegisterEvent("UPDATE_FACTION")
ReputationBarEvents:SetScript("OnEvent", UpdateReputationBar)

ReputationWatchBar.StatusBar:HookScript("OnEnter", RepTooltip)
ReputationWatchBar.StatusBar:HookScript("OnLeave", function() GameTooltip:Hide() end)