-- UPDATE MAIL FRAME AND CHECK MAIL

function UpdateMailFrame()
    C_Timer.After(0.5, function()
        CheckInbox()
        if MailFrame:IsShown() then
            MailFrame_Update()
        end
    end)
end

MailEvents = CreateFrame("Frame")
MailEvents:RegisterEvent("MAIL_SHOW")
MailEvents:SetScript("OnEvent", UpdateMailFrame)