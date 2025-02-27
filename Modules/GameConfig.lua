-- UPDATE GRAPHICS CONFIG

local function UpdateCVars()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("worldLatencyTextScale", 1.25)
    SetCVar("cameraDistanceMaxZoomFactor", 2.2)
    SetCVar("HardwareCursor", 1)
end

local GraphicsFrame = CreateFrame("Frame")
GraphicsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
GraphicsFrame:SetScript("OnEvent", UpdateCVars)


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

local SoundFrame = CreateFrame("Frame")
SoundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SoundFrame:SetScript("OnEvent", ApplySoundConfiguration)


-- ENFORCE DEFAULT SOUND OUTPUT

local function OnCVarChanged(event, cvar, value)
    if cvar == "Sound_OutputDriverIndex" and value ~= "0" then
        SetCVar("Sound_OutputDriverIndex", "0")
        Sound_GameSystem_RestartSoundSystem()
    end
end

local CVarFrame = CreateFrame("Frame")
CVarFrame:RegisterEvent("CVAR_UPDATE")
CVarFrame:SetScript("OnEvent", OnCVarChanged)