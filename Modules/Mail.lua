-- REFRESH MAIL MULTIPLE TIMES AFTER DELAY

function updateMailFrame()
    C_Timer.After(0.5, function()
        CheckInbox()
        CheckInbox()
        CheckInbox()
    end)
end

local mailEvents = CreateFrame("Frame")
mailEvents:RegisterEvent("MAIL_SHOW")
mailEvents:SetScript("OnEvent", updateMailFrame)