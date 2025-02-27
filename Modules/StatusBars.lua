-- UPDATE EXPERIENCE BAR

local XPBarBackdrop = CreateFrame("Frame", nil, MainMenuExpBar, "BackdropTemplate")
XPBarBackdrop:SetPoint("TOPLEFT", MainMenuExpBar, "TOPLEFT", -3, 3)
XPBarBackdrop:SetPoint("BOTTOMRIGHT", MainMenuExpBar, "BOTTOMRIGHT", 3, -3)
XPBarBackdrop:SetBackdrop({edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
XPBarBackdrop:SetBackdropBorderColor(unpack(N.RGB))
XPBarBackdrop:SetFrameStrata("HIGH")

local function HideXPTextures()
    for i = 0, 3 do
        local texture = _G["MainMenuXPBarTexture" .. i]
        if texture then
            texture:Hide()
            texture:SetScript("OnShow", function(self) self:Hide() end)
        end
    end
end

local function UpdateExperienceBar()
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
    MainMenuExpBar:SetStatusBarTexture(T.BAR)
    MainMenuExpBar:SetStatusBarColor(unpack(V.RGB))
    
    MainMenuExpBar:EnableMouse(true)
end

local ExperienceBarFrame = CreateFrame("Frame")
ExperienceBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ExperienceBarFrame:RegisterEvent("PLAYER_LEVEL_UP")
ExperienceBarFrame:RegisterEvent("PLAYER_XP_UPDATE")
ExperienceBarFrame:RegisterEvent("UPDATE_EXHAUSTION")
ExperienceBarFrame:SetScript("OnEvent", UpdateExperienceBar)


-- EXPERIENCE TOOLTIP FUNCTIONALITY

local function ExpTooltip()
    local CurrentExperience, MaxExperience = UnitXP("player"), UnitXPMax("player")
    local RestedExperience = GetXPExhaustion() or 0

    local ExpTooltipContent = string.format(
        "%sExperience%s\n" ..
        "%sProgress:%s %s%d%%%s\n" ..
        "%sRested:%s %s%d%%%s\n" ..
        "%sCurrent:%s %s%d%s\n" ..
        "%sMissing:%s %s%d%s\n" ..
        "%sTotal:%s %s%d%s",
        V.LUA, "|r",
        Y.LUA, "|r", W.LUA, math.floor((CurrentExperience / MaxExperience) * 100), "|r",
        Y.LUA, "|r", W.LUA, math.floor((RestedExperience / MaxExperience) * 100), "|r",
        Y.LUA, "|r", W.LUA, CurrentExperience, "|r",
        Y.LUA, "|r", W.LUA, MaxExperience - CurrentExperience, "|r",
        Y.LUA, "|r", W.LUA, MaxExperience, "|r"
    )

    GameTooltip:SetOwner(MainMenuExpBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
    GameTooltip:SetText(ExpTooltipContent, nil, nil, nil, nil, true)
    GameTooltip:Show()
end

MainMenuExpBar:HookScript("OnEnter", ExpTooltip)
MainMenuExpBar:HookScript("OnLeave", function() GameTooltip:Hide() end)


-- REPUTATION BAR

local RepBarBackdrop = CreateFrame("Frame", nil, ReputationWatchBar.StatusBar, "BackdropTemplate")
RepBarBackdrop:SetPoint("TOPLEFT", ReputationWatchBar.StatusBar, "TOPLEFT", -3, 3)
RepBarBackdrop:SetPoint("BOTTOMRIGHT", ReputationWatchBar.StatusBar, "BOTTOMRIGHT", 3, -3)
RepBarBackdrop:SetBackdrop({edgeFile = T.EDGE, edgeSize = T.EDGE_SIZE})
RepBarBackdrop:SetBackdropBorderColor(unpack(N.RGB))
RepBarBackdrop:SetFrameStrata("HIGH")

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

local function UpdateReputationBar()
    if not GetWatchedFactionInfo() then
        ReputationWatchBar.StatusBar:Hide()
        return
    end

    HideRepTextures()

    ReputationWatchBar.StatusBar:SetWidth(120)
    ReputationWatchBar.StatusBar:SetHeight(12)
    ReputationWatchBar.StatusBar:ClearAllPoints()
    ReputationWatchBar.StatusBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 16, -32)
    ReputationWatchBar.StatusBar:SetStatusBarTexture(T.BAR)
    ReputationWatchBar.StatusBar:SetStatusBarColor(unpack(BL.RGB))
    
    ReputationWatchBar.StatusBar:EnableMouse(true)
    ReputationWatchBar.StatusBar:Show()
end

local ReputationBarFrame = CreateFrame("Frame")
ReputationBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ReputationBarFrame:RegisterEvent("UPDATE_FACTION")
ReputationBarFrame:SetScript("OnEvent", UpdateReputationBar)


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
            BL.LUA, "|r",
            Y.LUA, "|r", W.LUA, name, "|r",
            Y.LUA, "|r", W.LUA, _G["FACTION_STANDING_LABEL"..standing], "|r",
            Y.LUA, "|r", W.LUA, progressPercent, "|r",
            Y.LUA, "|r", W.LUA, progress, "|r",
            Y.LUA, "|r", W.LUA, total, "|r"
        )

        GameTooltip:SetOwner(ReputationWatchBar.StatusBar, "ANCHOR_BOTTOMRIGHT", 4, -4)
        GameTooltip:SetText(RepTooltipContent, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end
end

ReputationWatchBar.StatusBar:HookScript("OnEnter", RepTooltip)
ReputationWatchBar.StatusBar:HookScript("OnLeave", function() GameTooltip:Hide() end)