-- Load the color configuration
local C = AddonColors

local function CommandsIntro()
    print(C.Y .. "/bentocmd" .. C.RESET .. " for available commands.")
end

local function PrintCommands()
    print(C.Y .. "/f KEYWORD" .. C.RESET .. ": " .. C.RESET .. "Filters all active channels for KEYWORD and reposts matching messages." .. C.RESET)
    print(C.Y .. "/f KEYWORD1+KEYWORD2" .. C.RESET .. ": " .. C.RESET .. "Filters all active channels for the combination of KEYWORD1 and KEYWORD2 and reposts matching messages." .. C.RESET)
    print(C.Y .. "/f" .. C.RESET .. ": " .. C.RESET .. "Clears and stops the filtering." .. C.RESET)

    print(C.Y .. "/bc MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Broadcasts the MESSAGE across all joined channels." .. C.RESET)
    print(C.Y .. "/bc N1-N2 MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Broadcasts the MESSAGE across all specified channels, where N1 and N2 are indicating the inclusive range of channels to be targeted." .. C.RESET)

    print(C.Y .. "/ww MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Sends the MESSAGE to all players in a currently open /who instance." .. C.RESET)
    print(C.Y .. "/ww N MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Sends the MESSAGE to the first N count of players in a currently open /who instance." .. C.RESET)
    print(C.Y .. "/ww -CLASS MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Sends the MESSAGE to all players who are not of the specified CLASS in a currently open /who instance." .. C.RESET)
    print(C.Y .. "/ww N -CLASS MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Sends the MESSAGE to the first N count of players who are not of the specified CLASS in a currently open /who instance." .. C.RESET)
    print(C.Y .. "/wl N MESSAGE" .. C.RESET .. ": " .. C.RESET .. "Sends the MESSAGE to the last N players who whispered you." .. C.RESET)

    print(C.Y .. "/rc" .. C.RESET .. ": " .. C.RESET .. "Perform a ready check." .. C.RESET)
    print(C.Y .. "/q" .. C.RESET .. ": " .. C.RESET .. "Leaves the current party or raid." .. C.RESET)
    print(C.Y .. "/ui" .. C.RESET .. ": " .. C.RESET .. "Reloads the user interface." .. C.RESET)
    print(C.Y .. "/gx" .. C.RESET .. ": " .. C.RESET .. "Restarts the graphics engine." .. C.RESET)
    print(C.Y .. "/lua" .. C.RESET .. ": " .. C.RESET .. "Toggles the display of LUA errors." .. C.RESET)
end

local IntroEvents = CreateFrame("Frame")
IntroEvents:RegisterEvent("PLAYER_LOGIN")
IntroEvents:SetScript("OnEvent", CommandsIntro)

SLASH_BENTOCMD1 = "/bentocmd"
SlashCmdList["BENTOCMD"] = function(msg, editBox)
    if msg == "" then
        PrintCommands()
    end
end





local KeywordTable = {}
local playerName = UnitName("player")

local function KeywordMatch(msg, senderName)
    local playerLink = "|Hplayer:" .. senderName .. "|h|cFFFFD500[" .. senderName .. "]: |r|h"
    print(playerLink .. msg)
    PlaySound(3175, "Master", true)
end


local function KeywordFilter(msg)
    for _, keywordSet in ipairs(KeywordTable) do
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


local function KeywordValidation(self, event, msg, senderName, languageName, channelName, ...)
    if next(KeywordTable) and strmatch(channelName, "%d+") then
        local channelNumber = tonumber(strmatch(channelName, "%d+"))
        if channelNumber and channelNumber >= 1 and channelNumber <= 20 and KeywordFilter(msg) then
            KeywordMatch(msg, senderName)
        end
    end
end


local FilterEvents = CreateFrame("Frame")
FilterEvents:SetScript("OnEvent", KeywordValidation)


SLASH_FILTER1 = "/f"
SlashCmdList["FILTER"] = function(msg)
    if msg == "" then
        wipe(KeywordTable)
        print("|cFFFFD500Filter:|r Cleared.")
        FilterEvents:UnregisterEvent("CHAT_MSG_CHANNEL")
    else
        if not FilterEvents:IsEventRegistered("CHAT_MSG_CHANNEL") then
            FilterEvents:RegisterEvent("CHAT_MSG_CHANNEL")
        end

        if strfind(msg, "+") then
            local keywordSets = {strsplit(" ", msg)}
            for _, set in ipairs(keywordSets) do
                if strfind(set, "+") then
                    local compoundSet = {}
                    for keyword in string.gmatch(set, "[^+]+") do
                        table.insert(compoundSet, keyword)
                    end
                    table.insert(KeywordTable, compoundSet)
                else
                    table.insert(KeywordTable, set)
                end
            end
        else
            table.insert(KeywordTable, msg)
        end

        local newKeywordsStr = ""
        for i, keywordSet in ipairs(KeywordTable) do
            if type(keywordSet) == "string" then
                newKeywordsStr = newKeywordsStr .. "\"" .. keywordSet .. "\""
            elseif type(keywordSet) == "table" then
                local compoundStr = table.concat(keywordSet, " + ")
                newKeywordsStr = newKeywordsStr .. "\"" .. compoundStr .. "\""
            end
            if i ~= #KeywordTable then
                newKeywordsStr = newKeywordsStr .. ", "
            end
        end
        print("|cFFFFD500Filtering:|r " .. newKeywordsStr:gsub('"', '') .. ".")
    end
end








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


local function TrackWhispers(_, _, msg, playerName)
    table.insert(recentWhispers, playerName)
    if #recentWhispers > 100 then
        table.remove(recentWhispers, 1)
    end
end


local WhisperLastEvents = CreateFrame("Frame")
WhisperLastEvents:RegisterEvent("CHAT_MSG_WHISPER")
WhisperLastEvents:SetScript("OnEvent", TrackWhispers)






















-- Close Tabs
local function CloseTabs()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
        local chatFrame = _G[chatFrameName]
        if chatFrame and chatFrame.isTemporary then
            FCF_Close(chatFrame)
        end
    end
end

SLASH_CLOSETABS1 = "/c"
SlashCmdList["CLOSETABS"] = CloseTabs


-- Ready Check
local function ReadyCheck()
    DoReadyCheck()
end

SLASH_READYCHECK1 = "/rc"
SlashCmdList["READYCHECK"] = ReadyCheck


-- Quit Party
local function QuitParty() 
    if IsInGroup() then 
        LeaveParty() 
    end 
end

SLASH_QUITPARTY1 = "/q"
SlashCmdList["QUITPARTY"] = QuitParty


-- Toggle Lua
local function ToggleLua()
    local currentSetting = GetCVar("scriptErrors")
    if currentSetting == "1" then
        SetCVar("scriptErrors", 0)
        print("LUA Errors Off")
    else
        SetCVar("scriptErrors", 1)
        print("LUA Errors On")
    end
end

SLASH_TOGGLELUA1 = "/lua"
SlashCmdList["TOGGLELUA"] = ToggleLua


SLASH_RELOADUI1 = "/ui"
SlashCmdList["RELOADUI"] = function()
    ReloadUI()
end

SLASH_GXRESTART1 = "/gx"
SlashCmdList["GXRESTART"] = function()
    ConsoleExec("gxRestart")
end