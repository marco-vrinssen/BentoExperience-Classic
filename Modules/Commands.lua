-- COMMAND INTRO MESSAGE

local function commandsIntro()
    print(YELLOW_CHAT_LUA .. "/bentocmd" .. "|r" .. " for available commands.")
end

local function showCommandList()
    print(YELLOW_CHAT_LUA .. "/f KEYWORD" .. "|r" .. ": " .. "|r" .. "Filters all active channels for KEYWORD and reposts matching messages." .. "|r")
    print(YELLOW_CHAT_LUA .. "/f KEYWORD1+KEYWORD2" .. "|r" .. ": " .. "|r" .. "Filters all active channels for the combination of KEYWORD1 and KEYWORD2 and reposts matching messages." .. "|r")
    print(YELLOW_CHAT_LUA .. "/f" .. "|r" .. ": " .. "|r" .. "Clears and stops the filtering." .. "|r")

    print(YELLOW_CHAT_LUA .. "/ww MESSAGE" .. "|r" .. ": " .. "|r" .. "Sends the MESSAGE to all players in a currently open /who instance." .. "|r")
    print(YELLOW_CHAT_LUA .. "/ww N MESSAGE" .. "|r" .. ": " .. "|r" .. "Sends the MESSAGE to the first N count of players in a currently open /who instance." .. "|r")
    print(YELLOW_CHAT_LUA .. "/ww -CLASS MESSAGE" .. "|r" .. ": " .. "|r" .. "Sends the MESSAGE to all players who are not of the specified CLASS in a currently open /who instance." .. "|r")
    print(YELLOW_CHAT_LUA .. "/ww N -CLASS MESSAGE" .. "|r" .. ": " .. "|r" .. "Sends the MESSAGE to the first N count of players who are not of the specified CLASS in a currently open /who instance." .. "|r")
    print(YELLOW_CHAT_LUA .. "/wl N MESSAGE" .. "|r" .. ": " .. "|r" .. "Sends the MESSAGE to the last N players who whispered you." .. "|r")

    print(YELLOW_CHAT_LUA .. "/rc" .. "|r" .. ": " .. "|r" .. "Perform a ready check." .. "|r")
    print(YELLOW_CHAT_LUA .. "/q" .. "|r" .. ": " .. "|r" .. "Leaves the current party or raid." .. "|r")
    print(YELLOW_CHAT_LUA .. "/ui" .. "|r" .. ": " .. "|r" .. "Reloads the user interface." .. "|r")
    print(YELLOW_CHAT_LUA .. "/gx" .. "|r" .. ": " .. "|r" .. "Restarts the graphics engine." .. "|r")
    print(YELLOW_CHAT_LUA .. "/lua" .. "|r" .. ": " .. "|r" .. "Toggles the display of LUA errors." .. "|r")
end

local introEvents = CreateFrame("Frame")
introEvents:RegisterEvent("PLAYER_LOGIN")
introEvents:SetScript("OnEvent", commandsIntro)

SLASH_BENTOCMD1 = "/bentocmd"
SlashCmdList["BENTOCMD"] = function(msg, editBox)
    if msg == "" then
        showCommandList()
    end
end


-- KEYWORD FILTERING

local keywordTable = {}
local playerName = UnitName("player")


local function keywordMatch(msg, senderName)
    local playerLink = "|Hplayer:" .. senderName .. "|h" .. YELLOW_CHAT_LUA .. "[" .. senderName .. "]: " .. "|r" .. "|h"
    print(playerLink .. msg)
    PlaySound(3175, "Master", true)
end


local function keywordFilter(msg)
    for _, keywordSet in ipairs(keywordTable) do
        if type(keywordSet) == "string" then
            local pattern = strlower(keywordSet)
            if strfind(strlower(msg), pattern) then
                return true
            end
        elseif type(keywordSet) == "table" then
            local allMatch = true
            for _, keyword in ipairs(keywordSet) do
                local pattern = strlower(keyword)
                if not strfind(strlower(msg), pattern) then
                    allMatch = false
                    break
                end
            end
            if allMatch then
                return true
            end
        end
    end
    return false
end


local function keywordValidation(self, event, msg, senderName, languageName, channelName, ...)
    if next(keywordTable) and strmatch(channelName, "%d+") then
        local channelNumber = tonumber(strmatch(channelName, "%d+"))
        if channelNumber and channelNumber >= 1 and channelNumber <= 20 and keywordFilter(msg) then
            keywordMatch(msg, senderName)
        end
    end
end


local filterCommandEvents = CreateFrame("Frame")
filterCommandEvents:SetScript("OnEvent", keywordValidation)


SLASH_FILTER1 = "/f"
SlashCmdList["FILTER"] = function(msg)
    if msg == "" then
        wipe(keywordTable)
        print(YELLOW_CHAT_LUA .. "Filter:" .. "|r" .. " Cleared.")
        filterCommandEvents:UnregisterEvent("CHAT_MSG_CHANNEL")
    else
        if not filterCommandEvents:IsEventRegistered("CHAT_MSG_CHANNEL") then
            filterCommandEvents:RegisterEvent("CHAT_MSG_CHANNEL")
        end

        if strfind(msg, "+") then
            local keywordSets = {strsplit(" ", msg)}
            for _, set in ipairs(keywordSets) do
                if strfind(set, "+") then
                    local compoundSet = {}
                    for keyword in string.gmatch(set, "[^+]+") do
                        table.insert(compoundSet, keyword)
                    end
                    table.insert(keywordTable, compoundSet)
                else
                    table.insert(keywordTable, set)
                end
            end
        else
            table.insert(keywordTable, msg)
        end

        local newKeywordsStr = ""
        for i, keywordSet in ipairs(keywordTable) do
            if type(keywordSet) == "string" then
                newKeywordsStr = newKeywordsStr .. "\"" .. keywordSet .. "\""
            elseif type(keywordSet) == "table" then
                local compoundStr = table.concat(keywordSet, " + ")
                newKeywordsStr = newKeywordsStr .. "\"" .. compoundStr .. "\""
            end
            if i ~= #keywordTable then
                newKeywordsStr = newKeywordsStr .. ", "
            end
        end
        print(YELLOW_CHAT_LUA .. "Filtering:" .. "|r" .. " " .. newKeywordsStr:gsub('"', '') .. ".")
    end
end



-- WHISPER ALL PLAYERS IN /WHO COMMAND

SLASH_WHISPERWHO1 = "/ww"
SlashCmdList["WHISPERWHO"] = function(msg)
    local limit, classExclusion, message

    limit, classExclusion, message = msg:match("^(%d+)%s*-%s*(%w+)%s+(.+)$")
    if not limit then
        limit, message = msg:match("^(%d+)%s+(.+)$")
        if not limit then
            classExclusion, message = msg:match("^%-(%w+)%s+(.+)$")
            if not classExclusion then
                message = msg
            end
        end
    end

    local numWhos = C_FriendList.GetNumWhoResults()

    if limit then
        limit = tonumber(limit)
    else
        limit = numWhos
    end

    if classExclusion then
        classExclusion = classExclusion:lower()
    end

    if message and message ~= "" and numWhos and numWhos > 0 then
        local count = 0
        for i = 1, numWhos do
            if count >= limit then break end
            local info = C_FriendList.GetWhoInfo(i)
            if info and info.fullName then
                if classExclusion then
                    if info.classStr:lower() ~= classExclusion then
                        SendChatMessage(message, "WHISPER", nil, info.fullName)
                        count = count + 1
                    end
                else
                    SendChatMessage(message, "WHISPER", nil, info.fullName)
                    count = count + 1
                end
            end
        end
    end
end


-- WHISPER RECENT PLAYERS

local recentWhispers = {}

SLASH_WHISPERLASTN1 = "/wl"
SlashCmdList["WHISPERLASTN"] = function(msg)
    local num, message = msg:match("^(%d+) (.+)$")

    if not num then
        message = msg
        num = #recentWhispers
    else
        num = tonumber(num)
    end

    if num and message and message ~= "" then
        local whispered = {}
        for i = math.max(#recentWhispers - num + 1, 1), #recentWhispers do
            local playerName = recentWhispers[i]
            if playerName and not whispered[playerName] then
                SendChatMessage(message, "WHISPER", nil, playerName)
                whispered[playerName] = true
            end
        end
    end
end

local function trackWhispers(_, _, msg, playerName)
    table.insert(recentWhispers, playerName)
    if #recentWhispers > 100 then
        table.remove(recentWhispers, 1)
    end
end

local latestWhispEvents = CreateFrame("Frame")
latestWhispEvents:RegisterEvent("CHAT_MSG_WHISPER")
latestWhispEvents:SetScript("OnEvent", trackWhispers)


-- CLOSE ALL WHISPER TABS

local function closeAllChatTabs()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatFrameName]
        if chatFrame and chatFrame.isTemporary then
            FCF_Close(chatFrame)
        end
    end
end

SLASH_CLOSETABS1 = "/c"
SlashCmdList["CLOSETABS"] = closeAllChatTabs


-- READY CHECK

local function readyCheck()
    DoReadyCheck()
end

SLASH_READYCHECK1 = "/rc"
SlashCmdList["READYCHECK"] = readyCheck


-- QUIT GROUP

local function quitParty() 
    if IsInGroup() then 
        LeaveParty() 
    end 
end

SLASH_QUITPARTY1 = "/q"
SlashCmdList["QUITPARTY"] = quitParty


-- TOGGLE LUA ERRORS

local function toggleLUAErrors()
    local currentSetting = GetCVar("scriptErrors")
    if currentSetting == "1" then
        SetCVar("scriptErrors", 0)
        print(YELLOW_CHAT_LUA .. "LUA Errors: " .. "|r" .. WHITE_CHAT_LUA .. "Disabled" .. "|r")
    else
        SetCVar("scriptErrors", 1)
        print(YELLOW_CHAT_LUA .. "LUA Errors: " .. "|r" .. WHITE_CHAT_LUA .. "Enabled" .. "|r")
    end
end

SLASH_TOGGLELUA1 = "/lua"
SlashCmdList["TOGGLELUA"] = toggleLUAErrors


-- RELOAD THE UI

SLASH_RELOADUI1 = "/ui"
SlashCmdList["RELOADUI"] = function()
    ReloadUI()
end


-- RESTART THE GRAPHICS ENGINE

SLASH_GXRESTART1 = "/gx"
SlashCmdList["GXRESTART"] = function()
    ConsoleExec("gxRestart")
end


-- RELOAD THE UI AND RESTART THE GRAPHICS ENGINE AND CLEAR GAME CACHE

local function fullReload()
    ReloadUI()
    ConsoleExec("gxRestart")
    ConsoleExec("clearCache")
end

SLASH_FULLRELOAD1 = "/rl"
SlashCmdList["FULLRELOAD"] = fullReload