-- UPDATE CHAT FRAME

local function hideUIElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function hideChildUIElements(parentFrame, childElementNames)
    for _, childName in ipairs(childElementNames) do
        local childElement = _G[parentFrame:GetName() .. childName] or parentFrame[childName]
        hideUIElement(childElement)
    end
end

local function hideFrameTextures(frame)
    for _, region in ipairs({frame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            hideUIElement(region)
        end
    end
end

local function customizeChatTab(chatFrame)
    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatFrame:GetName() .. "TabText"]
    
    hideFrameTextures(chatTab)
    if chatTabText then
        chatTabText:SetFont(FONT, 14)
        chatTabText:ClearAllPoints()
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end
end

local function addCustomBackdropToEditBox(editBox)
    if editBox and not editBox.customBackdrop then
        local editBoxBackdrop = CreateFrame("Frame", nil, editBox, "BackdropTemplate")
        editBoxBackdrop:SetPoint("TOPLEFT", editBox, "TOPLEFT", 0, 0)
        editBoxBackdrop:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMRIGHT", 0, 0)
        editBoxBackdrop:SetBackdrop({
            bgFile = BG,
            edgeFile = BORD,
            edgeSize = 12,
            insets = {left = 2, right = 2, top = 2, bottom = 2}
        })
        editBoxBackdrop:SetBackdropColor(unpack(BLACK_UI))
        editBoxBackdrop:SetBackdropBorderColor(unpack(GREY_UI))
        editBox.customBackdrop = editBoxBackdrop
        
        
        -- SET BACKDROP BELOW CONTENT
        
        editBoxBackdrop:SetFrameLevel(editBox:GetFrameLevel() - 1)
    end
end

local function customizeChatFrame(chatFrame)
    hideFrameTextures(chatFrame)
    
    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }
    
    hideChildUIElements(chatFrame, elementsToHide)
    customizeChatTab(chatFrame)
    
    local editBox = _G[chatFrame:GetName() .. "EditBox"]
    if editBox then
        addCustomBackdropToEditBox(editBox)
    end
end

local function alignEditBoxHeaders()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 8, 0)
        end
    end
end

local function updateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        local chatFrame = _G["ChatFrame" .. i]
        customizeChatFrame(chatFrame)
        
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        if editBox then
            addCustomBackdropToEditBox(editBox)
        end
    end
    
    hideUIElement(ChatFrameMenuButton)
    hideUIElement(ChatFrameChannelButton)
    if CombatLogQUIckButtonFrame_Custom then
        CombatLogQUIckButtonFrame_Custom:SetAlpha(0)
    end
    
    alignEditBoxHeaders()
end

local function hookChatTabScroll(chatFrameID)
    local chatTab = _G["ChatFrame" .. chatFrameID .. "Tab"]
    if not chatTab.scrollHooked then
        chatTab:HookScript("OnClick", function() _G["ChatFrame" .. chatFrameID]:ScrollToBottom() end)
        chatTab.scrollHooked = true
    end
end

local function updateChatScrollBehavior()
    for i = 1, NUM_CHAT_WINDOWS do
        hookChatTabScroll(i)
    end
end

local function onChatEvent()
    updateAllChatFrames()
    updateChatScrollBehavior()
end

local chatEvents = CreateFrame("Frame")
chatEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
chatEvents:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatEvents:RegisterEvent("CHAT_MSG_WHISPER")
chatEvents:RegisterEvent("UI_SCALE_CHANGED")
chatEvents:SetScript("OnEvent", onChatEvent)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        customizeChatFrame(currentChatFrame)
        hookChatTabScroll(currentChatFrame:GetID())
        alignEditBoxHeaders()
        
        local editBox = _G[currentChatFrame:GetName() .. "EditBox"]
        if editBox then
            addCustomBackdropToEditBox(editBox)
        end
    end
end)


-- RECOLOR INCOMING PINK_CHAT MESSAGES

local function recolorWhisperMessages(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, PINK_LIGHT_CHAT_LUA .. message .. "|r", sender, ...
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhisperMessages)


-- SET CUSTOM CHAT COLORS

local function updateChatColors()

    SetCVar("chatClassColorOverride", "0")
    
    local chatTypes = {
        "SAY", "EMOTE", "YELL", "GREEN_CHAT", "OFFICER", "PINK_CHAT",
        "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
        "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "VOICE_TEXT"
    }

    for _, v in ipairs(chatTypes) do
        SetChatColorNameByClass(v, true)
    end

    for i = 1, 50 do
        SetChatColorNameByClass("CORAL_CHAT" .. i, true)
    end
    

    -- PLAYER MESSAGES COLORS

    ChangeChatColor("SAY", unpack(CORAL_CHAT))
    ChangeChatColor("EMOTE", unpack(CORAL_CHAT))
    ChangeChatColor("YELL", unpack(CORAL_CHAT))
    ChangeChatColor("GREEN_CHAT", unpack(GREEN_CHAT))
    ChangeChatColor("OFFICER", unpack(GREEN_CHAT))
    ChangeChatColor("PINK_CHAT", unpack(PINK_CHAT))
    ChangeChatColor("WHISPER_INFORM", unpack(PINK_CHAT))
    ChangeChatColor("BN_WHISPER", unpack(PINK_CHAT))
    ChangeChatColor("BN_WHISPER_INFORM", unpack(PINK_CHAT))
    ChangeChatColor("WHISPER", unpack(PINK_CHAT))  -- Use RGB values for chat color
    ChangeChatColor("BN_WHISPER", unpack(PINK_CHAT))  -- Use RGB values for chat color
    ChangeChatColor("RAID", unpack(BLUE_CHAT))
    ChangeChatColor("RAID_LEADER", unpack(BLUE_CHAT)) 
    ChangeChatColor("RAID_WARNING", unpack(BLUE_CHAT))
    ChangeChatColor("PARTY", unpack(BLUE_CHAT))
    ChangeChatColor("PARTY_LEADER", unpack(BLUE_CHAT))
    ChangeChatColor("INSTANCE_CHAT", unpack(BLUE_CHAT))
    ChangeChatColor("INSTANCE_CHAT_LEADER", unpack(BLUE_CHAT))


    -- CORAL_CHAT COLORS

    for i = 1, GetNumDisplayChannels() do
        local _, _, _, channelID = GetChannelDisplayInfo(i)
        if channelID then
            ChangeChatColor("CHANNEL"..channelID, unpack(CORAL_CHAT))
        end
    end


    -- COMBAT COLORS
    
    ChangeChatColor("COMBAT_XP_GAIN", unpack(YELLOW_CHAT))
    ChangeChatColor("COMBAT_HONOR_GAIN", unpack(YELLOW_CHAT)) 
    ChangeChatColor("COMBAT_FACTION_CHANGE", unpack(YELLOW_CHAT))  -- Reputation
    ChangeChatColor("SKILL", unpack(YELLOW_CHAT))  -- Skill-ups
    ChangeChatColor("LOOT", unpack(YELLOW_CHAT))  -- Item loot
    ChangeChatColor("MONEY", unpack(YELLOW_CHAT))  -- Money loot
    ChangeChatColor("TRADESKILLS", unpack(YELLOW_CHAT))  -- Tradeskills
    ChangeChatColor("OPENING", unpack(YELLOW_CHAT))  -- Opening
    ChangeChatColor("PET_INFO", unpack(YELLOW_CHAT))  -- Pet Info
    ChangeChatColor("COMBAT_MISC_INFO", unpack(YELLOW_CHAT))  -- Misc Info

    -- PVP COLORS 

    ChangeChatColor("BG_HORDE", unpack(BLUE_CHAT))  -- Battleground Horde
    ChangeChatColor("BG_ALLIANCE", unpack(BLUE_CHAT))  -- Battleground Alliance
    ChangeChatColor("BG_NEUTRAL", unpack(BLUE_CHAT))  -- Battleground Neutral

    -- YELLOW_CHAT COLORS

    ChangeChatColor("YELLOW_CHAT", unpack(YELLOW_CHAT))  -- System Messages
    ChangeChatColor("ERRORS", unpack(YELLOW_CHAT))  -- Errors
    ChangeChatColor("IGNORED", unpack(YELLOW_CHAT))  -- Ignored
    ChangeChatColor("CORAL_CHAT", unpack(YELLOW_CHAT))  -- Channel
    ChangeChatColor("TARGETICONS", unpack(YELLOW_CHAT))  -- Target Icons
    ChangeChatColor("BN_INLINE_TOAST_ALERT", unpack(BLUE_CHAT))  -- Blizzard Services Alerts

    -- CREATURE COLORS

    ChangeChatColor("MONSTER_SAY", unpack(CORAL_CHAT))  -- Creature Say
    ChangeChatColor("MONSTER_EMOTE", unpack(CORAL_CHAT))  -- Creature Emote
    ChangeChatColor("MONSTER_YELL", unpack(CORAL_CHAT))  -- Creature Yell
    ChangeChatColor("MONSTER_WHISPER", unpack(PINK_CHAT))  -- Creature Whisper
    ChangeChatColor("MONSTER_BOSS_EMOTE", unpack(CORAL_CHAT))  -- Boss Emote
    ChangeChatColor("MONSTER_BOSS_WHISPER", unpack(PINK_CHAT))  -- Boss Whisper

end

local chatColorEvents = CreateFrame("Frame")
chatColorEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
chatColorEvents:SetScript("OnEvent", updateChatColors)