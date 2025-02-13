local function HideBar(bar, textures)
    for _, texture in ipairs(textures) do
        texture:Hide()
        texture:SetAlpha(0)
    end
    bar:Hide()
    bar:SetAlpha(0)
end

local function ShowBar(bar, textures)
    bar:Show()
    for _, texture in ipairs(textures) do
        texture:Hide()
    end
    bar:SetAlpha(1)
end

local function CreateBackdrop(frame)
    local backdrop = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2)
    backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2)
    backdrop:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 8})
    backdrop:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
    backdrop:SetFrameStrata("HIGH")
    return backdrop
end

local function UpdateExperienceBar()
    if UnitLevel("player") < MAX_PLAYER_LEVEL then
        MainMenuExpBar:SetWidth(120)
        MainMenuExpBar:SetHeight(12)
        MainMenuExpBar:ClearAllPoints()
        MainMenuExpBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -16)
        MainMenuExpBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        MainMenuExpBar:SetStatusBarColor(0.23, 0.19, 0.31)
        if not MainMenuExpBar.backdrop then
            MainMenuExpBar.backdrop = CreateBackdrop(MainMenuExpBar)
        end
        ShowBar(MainMenuExpBar, {
            MainMenuXPBarTexture0,
            MainMenuXPBarTexture1,
            MainMenuXPBarTexture2,
            MainMenuXPBarTexture3
        })
    else
        HideBar(MainMenuExpBar, {
            MainMenuXPBarTexture0,
            MainMenuXPBarTexture1,
            MainMenuXPBarTexture2,
            MainMenuXPBarTexture3
        })
    end
end

local function UpdateReputationBar()
    if GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:SetWidth(120)
        ReputationWatchBar.StatusBar:SetHeight(12)
        ReputationWatchBar.StatusBar:ClearAllPoints()
        ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", MainMenuExpBar, "BOTTOMLEFT", 0, -8)
        ReputationWatchBar.StatusBar:SetStatusBarTexture("Interface/RaidFrame/Raid-Bar-HP-Fill.blp")
        ReputationWatchBar.StatusBar:SetStatusBarColor(0.19, 0.31, 0.23)
        if not ReputationWatchBar.StatusBar.backdrop then
            ReputationWatchBar.StatusBar.backdrop = CreateBackdrop(ReputationWatchBar.StatusBar)
        end
        ShowBar(ReputationWatchBar.StatusBar, {
            ReputationWatchBar.StatusBar.WatchBarTexture0,
            ReputationWatchBar.StatusBar.WatchBarTexture1,
            ReputationWatchBar.StatusBar.WatchBarTexture2,
            ReputationWatchBar.StatusBar.WatchBarTexture3
        })
        ReputationWatchBar.OverlayFrame:Hide()
    else
        HideBar(ReputationWatchBar.StatusBar, {
            ReputationWatchBar.StatusBar.WatchBarTexture0,
            ReputationWatchBar.StatusBar.WatchBarTexture1,
            ReputationWatchBar.StatusBar.WatchBarTexture2,
            ReputationWatchBar.StatusBar.WatchBarTexture3
        })
    end
end

MainMenuExpBar:HookScript("OnShow", UpdateExperienceBar)
MainMenuExpBar:HookScript("OnHide", function() 
    HideBar(MainMenuExpBar, {
        MainMenuXPBarTexture0,
        MainMenuXPBarTexture1,
        MainMenuXPBarTexture2,
        MainMenuXPBarTexture3
    }) 
end)

ReputationWatchBar.StatusBar:HookScript("OnShow", UpdateReputationBar)
ReputationWatchBar.StatusBar:HookScript("OnHide", function() 
    HideBar(ReputationWatchBar.StatusBar, {
        ReputationWatchBar.StatusBar.WatchBarTexture0,
        ReputationWatchBar.StatusBar.WatchBarTexture1,
        ReputationWatchBar.StatusBar.WatchBarTexture2,
        ReputationWatchBar.StatusBar.WatchBarTexture3
    }) 
end)

local TrackingBarEvents = CreateFrame("Frame")
TrackingBarEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
TrackingBarEvents:RegisterEvent("PLAYER_LEVEL_UP")
TrackingBarEvents:RegisterEvent("PLAYER_XP_UPDATE")
TrackingBarEvents:RegisterEvent("UPDATE_EXHAUSTION")
TrackingBarEvents:RegisterEvent("UPDATE_FACTION")
TrackingBarEvents:SetScript("OnEvent", function(self, event)
    UpdateExperienceBar()
    UpdateReputationBar()
end)

local function PlayerLevelTooltip()
    local CurrentExperience, MaxExperience = UnitXP("player"), UnitXPMax("player")
    local RestedExperience = GetXPExhaustion() or 0

    local ExperienceText = string.format(
        "|cFFFFFFFFExperience|r\n\n" ..
        "|cFFFFCC00Progress:|r |cFFFFFFFF%d%%|r\n" ..
        "|cFFFFCC00Rested:|r |cFFFFFFFF%d%%|r\n" ..
        "|cFFFFCC00Current:|r |cFFFFFFFF%d|r\n" ..
        "|cFFFFCC00Missing:|r |cFFFFFFFF%d|r\n" ..
        "|cFFFFCC00Total:|r |cFFFFFFFF%d|r",
        math.floor((CurrentExperience / MaxExperience) * 100),
        math.floor((RestedExperience / MaxExperience) * 100),
        CurrentExperience,
        MaxExperience - CurrentExperience,
        MaxExperience
    )

    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    GameTooltip:SetText(ExperienceText, nil, nil, nil, nil, true)
    GameTooltip:Show()
end

local function ReputationTooltip()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if name then
        local progress = value - min
        local total = max - min
        local progressPercent = math.floor((progress / total) * 100)

        local ReputationText = string.format(
            "|cFFFFFFFFReputation|r\n\n" ..
            "|cFFFFCC00Faction:|r |cFFFFFFFF%s|r\n" ..
            "|cFFFFCC00Standing:|r |cFFFFFFFF%s|r\n" ..
            "|cFFFFCC00Progress:|r |cFFFFFFFF%d%%|r\n" ..
            "|cFFFFCC00Current:|r |cFFFFFFFF%d|r\n" ..
            "|cFFFFCC00Total:|r |cFFFFFFFF%d|r",
            name,
            _G["FACTION_STANDING_LABEL"..standing],
            progressPercent,
            progress,
            total
        )

        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:SetText(ReputationText, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

MainMenuExpBar:SetScript("OnEnter", PlayerLevelTooltip)
MainMenuExpBar:SetScript("OnLeave", function() GameTooltip:Hide() end)
ReputationWatchBar.StatusBar:SetScript("OnEnter", ReputationTooltip)
ReputationWatchBar.StatusBar:SetScript("OnLeave", function() GameTooltip:Hide() end)