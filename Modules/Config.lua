-- UPDATE GRAPHICS CONFIG

local function updateCVars()
    SetCVar("ffxGlow", 0)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("WorldTextScale", 1.25)
    SetCVar("cameraDistanceMaxZoomFactor", 2.2)
    SetCVar("HardwareCursor", 1)
end

local graphicsFrame = CreateFrame("Frame")
graphicsFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
graphicsFrame:SetScript("OnEvent", updateCVars)


-- MUTE SOUNDS

local mutedSounds = {
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

local function applySoundConfiguration()
    for _, soundId in ipairs(mutedSounds) do
        MuteSoundFile(soundId)
    end
end

local soundFrame = CreateFrame("Frame")
soundFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
soundFrame:SetScript("OnEvent", applySoundConfiguration)


-- ENFORCE DEFAULT SOUND OUTPUT

local function onCVarChanged(event, cvar, value)
    if cvar == "Sound_OutputDriverIndex" and value ~= "0" then
        SetCVar("Sound_OutputDriverIndex", "0")
        Sound_GameSystem_RestartSoundSystem()
    end
end

local cVarFrame = CreateFrame("Frame")
cVarFrame:RegisterEvent("CVAR_UPDATE")
cVarFrame:SetScript("OnEvent", onCVarChanged)