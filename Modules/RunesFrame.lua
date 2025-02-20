local EngravingFrameHidden = false

local EngraveEvents = CreateFrame("Frame")

local function CheckAndHideEngravingFrame()
    if RuneFrameControlButton and RuneFrameControlButton:IsVisible() and not EngravingFrameHidden then
        if EngravingFrame and EngravingFrame:IsShown() then
            EngravingFrame:Hide()
            EngravingFrameHidden = true
        end
    end
end

local function ResetEngravingFrameHiddenFlag()
    if RuneFrameControlButton and not RuneFrameControlButton:IsVisible() then
        EngravingFrameHidden = false
    end
end

local function OnUpdateHandler(self, elapsed)
    CheckAndHideEngravingFrame()
    ResetEngravingFrameHiddenFlag()
end

EngraveEvents:SetScript("OnUpdate", OnUpdateHandler)