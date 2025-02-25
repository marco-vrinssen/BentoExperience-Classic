-- UPDATE GRAPHIC CONFIG VALUES

local function UpdateCVars()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("WorldTextScale", 1.25)
    SetCVar("cameraDistanceMaxZoomFactor", 2.2)
    SetCVar("HardwareCursor", 1)
end

local GraphicsEvents = CreateFrame("Frame")
GraphicsEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
GraphicsEvents:SetScript("OnEvent", UpdateCVars)




-- MUTE SOUNDS

local MutedSounds = {
    555124,
    548067,
    567677,
    567675,
    567676,
    567719,
    567720,
    567723,
    567721,
}

local function ApplySoundConfiguration()
    for _, SoundID in ipairs(MutedSounds) do
        MuteSoundFile(SoundID)
    end
end

local SoundEvents = CreateFrame("Frame")
SoundEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SoundEvents:SetScript("OnEvent", ApplySoundConfiguration)




-- ENSURE DEFAULT SOUNDOUT

local function OnCVarChanged(event, cvar, value)
    if cvar == "Sound_OutputDriverIndex" and value ~= "0" then
        SetCVar("Sound_OutputDriverIndex", "0")
        Sound_GameSystem_RestartSoundSystem()
    end
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("CVAR_UPDATE")
CVarEvents:SetScript("OnEvent", OnCVarChanged)




-- UPDATE FRAMERATE DISPLAY

local function FramerateUpdate()
    FramerateLabel:SetAlpha(0)
    FramerateText:ClearAllPoints()
    FramerateText:SetPoint("TOP", UIParent, "TOP", 0, -16)
end

local FramerateEvents = CreateFrame("Frame")
FramerateEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
FramerateEvents:SetScript("OnEvent", FramerateUpdate)