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

local function customizeChatFrame(chatFrame)
    hideFrameTextures(chatFrame)
    
    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }
    
    hideChildUIElements(chatFrame, elementsToHide)
    customizeChatTab(chatFrame)
end

local function alignEditBoxHeaders()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 6, 0)
        end
    end
end

local function updateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        customizeChatFrame(_G["ChatFrame" .. i])
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
    end
end)


-- RECOLOR INCOMING WHISPER MESSAGES

local function recolorWhisperMessages(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, LIGHTPINK_LUA .. message .. "|r", sender, ...
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", recolorWhisperMessages)


-- UPDATE CLASS COLORS IN CHAT

SetCVar("chatClassColorOverride", "0")

local chatTypes = {
    "SAY", "EMOTE", "YELL", "GUILD", "OFFICER", "WHISPER",
    "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING",
    "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "VOICE_TEXT"
}

for _, v in ipairs(chatTypes) do
    SetChatColorNameByClass(v, true)
end

for i = 1, 50 do
    SetChatColorNameByClass("CHANNEL" .. i, true)
end