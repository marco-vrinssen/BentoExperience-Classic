-- UPDATE CHAT FRAME

local function HideUIElement(element)
    if element then
        element:Hide()
        element:SetScript("OnShow", element.Hide)
    end
end

local function HideChildUIElements(parentFrame, childElementNames)
    for _, childName in ipairs(childElementNames) do
        local childElement = _G[parentFrame:GetName() .. childName] or parentFrame[childName]
        HideUIElement(childElement)
    end
end

local function HideFrameTextures(frame)
    for _, region in ipairs({frame:GetRegions()}) do
        if region:IsObjectType("Texture") then
            HideUIElement(region)
        end
    end
end

local function CustomizeChatTab(chatFrame)
    local chatTab = _G[chatFrame:GetName() .. "Tab"]
    local chatTabText = _G[chatFrame:GetName() .. "TabText"]
    
    HideFrameTextures(chatTab)
    if chatTabText then
        chatTabText:SetFont(STANDARD_TEXT_FONT, 14)
        chatTabText:ClearAllPoints()
        chatTabText:SetPoint("LEFT", chatTab, "LEFT", 4, 0)
    end
end

local function CustomizeChatFrame(chatFrame)
    HideFrameTextures(chatFrame)
    
    local elementsToHide = {
        "ButtonFrame", "EditBoxLeft", "EditBoxMid", "EditBoxRight",
        "EditBoxHeaderSuffix", "TabUpButton", "TabDownButton",
        "TabBottomButton", "TabMinimizeButton"
    }
    
    HideChildUIElements(chatFrame, elementsToHide)
    CustomizeChatTab(chatFrame)
end

local function AlignEditBoxHeaders()
    for i = 1, NUM_CHAT_WINDOWS do
        local editBox = _G["ChatFrame" .. i .. "EditBox"]
        local editBoxHeader = _G["ChatFrame" .. i .. "EditBoxHeader"]
        if editBox and editBoxHeader then
            editBoxHeader:ClearAllPoints()
            editBoxHeader:SetPoint("LEFT", editBox, "LEFT", 6, 0)
        end
    end
end

local function UpdateAllChatFrames()
    for i = 1, NUM_CHAT_WINDOWS do
        CustomizeChatFrame(_G["ChatFrame" .. i])
    end
    
    HideUIElement(ChatFrameMenuButton)
    HideUIElement(ChatFrameChannelButton)
    if CombatLogQuickButtonFrame_Custom then
        CombatLogQuickButtonFrame_Custom:SetAlpha(0)
    end
    
    AlignEditBoxHeaders()
end

local function HookChatTabScroll(chatFrameID)
    local chatTab = _G["ChatFrame" .. chatFrameID .. "Tab"]
    if not chatTab.scrollHooked then
        chatTab:HookScript("OnClick", function() _G["ChatFrame" .. chatFrameID]:ScrollToBottom() end)
        chatTab.scrollHooked = true
    end
end

local function UpdateChatScrollBehavior()
    for i = 1, NUM_CHAT_WINDOWS do
        HookChatTabScroll(i)
    end
end

local function OnChatEvent()
    UpdateAllChatFrames()
    UpdateChatScrollBehavior()
end

local chatEvents = CreateFrame("Frame")
chatEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
chatEvents:RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
chatEvents:RegisterEvent("CHAT_MSG_WHISPER")
chatEvents:RegisterEvent("UI_SCALE_CHANGED")
chatEvents:SetScript("OnEvent", OnChatEvent)

hooksecurefunc("FCF_OpenTemporaryWindow", function()
    local currentChatFrame = FCF_GetCurrentChatFrame()
    if currentChatFrame then
        CustomizeChatFrame(currentChatFrame)
        HookChatTabScroll(currentChatFrame:GetID())
        AlignEditBoxHeaders()
    end
end)




-- RECOLOR INCOMING WHISPER MESSAGES

local function RecolorWhisperMessages(self, event, message, sender, ...)
    if event == "CHAT_MSG_WHISPER" then
        return false, "|cFFFFCCFE" .. message .. "|r", sender, ...
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", RecolorWhisperMessages)




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