-- AUTO CONFIRM DIALOGS

local StaticPopup_Hide = StaticPopup_Hide


-- DIALOG HANDLERS

local eventHandlers = {
    CONFIRM_LOOT_ROLL = function(arg1, arg2)
        ConfirmLootRoll(arg1, arg2)
        StaticPopup_Hide("CONFIRM_LOOT_ROLL")
    end,
    
    LOOT_BIND_CONFIRM = function(arg1, arg2, ...)
        ConfirmLootSlot(arg1, arg2)
        StaticPopup_Hide("LOOT_BIND", ...)
    end,
    
    MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL = SellCursorItem,
    
    MAIL_LOCK_SEND_ITEMS = function(arg1)
        RespondMailLockSendItem(arg1, true)
    end,
    
    EQUIP_BIND_CONFIRM = function(arg1)
        EquipPendingItem(arg1)
        StaticPopup_Hide("EQUIP_BIND")
    end,
    
    EQUIP_BIND_TRADEABLE_CONFIRM = function(arg1)
        StaticPopupDialogs["EQUIP_BIND_TRADEABLE"]:OnAccept(arg1)
        StaticPopup_Hide("EQUIP_BIND_TRADEABLE")
    end,
    
    DELETE_ITEM_CONFIRM = DeleteCursorItem
}


-- SETUP EVENT HANDLING

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(_, event, arg1, arg2, ...)
    local handler = eventHandlers[event]
    if handler then handler(arg1, arg2, ...) end
end)

for event in pairs(eventHandlers) do
    frame:RegisterEvent(event)
end