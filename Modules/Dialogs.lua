-- AUTO CONFIRM DIALOGS

local function confirmDialog(event, arg1, arg2, ...)
    if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
        ConfirmLootRoll(arg1, arg2)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
        return
    end

    if event == "LOOT_BIND_CONFIRM" then
        ConfirmLootSlot(arg1, arg2)
        StaticPopup_Hide("LOOT_BIND",...)
        return
    end

    if event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
        SellCursorItem()
        return
    end

    if event == "MAIL_LOCK_SEND_ITEMS" then
        RespondMailLockSendItem(arg1, true)
        return
    end
end

local confirmationEvents = CreateFrame("Frame")
confirmationEvents:RegisterEvent("CONFIRM_LOOT_ROLL")
confirmationEvents:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
confirmationEvents:RegisterEvent("LOOT_BIND_CONFIRM")
confirmationEvents:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
confirmationEvents:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
confirmationEvents:SetScript("OnEvent", confirmDialog)