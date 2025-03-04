-- UPDATE MAIL FRAME AND CHECK MAIL

function updateMailFrame()
    C_Timer.After(0.5, function()
        CheckInbox()
        MailFrame_Update()
    end)
end

local mailEvents = CreateFrame("Frame")
mailEvents:RegisterEvent("MAIL_SHOW")
mailEvents:SetScript("OnEvent", updateMailFrame)