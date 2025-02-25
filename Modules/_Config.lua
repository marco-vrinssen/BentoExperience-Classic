-- Define global addon colors
AddonColors = {
    B = "|cFF2871D9", -- 2871D9
    Y = "|cFFFBD134", -- FBD134
    YL = "|cFFFDFE9E", -- FDFE9E
    G = "|cFF24FE31", -- 24FE31
    P = "|cFFA43BEA", -- A43BEA
    PL = "|cFFFB18B2", -- FB18B2
    W = "|cFFFFFFFF", -- FFFFFF
    RESET = "|r" -- Resets Custom Coloring
}




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




-- Define muted sound
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

-- Apply sound configuration
local function ApplySoundConfiguration()
    for _, SoundID in ipairs(MutedSounds) do
        MuteSoundFile(SoundID)
    end
end

local SoundEvents = CreateFrame("Frame")
SoundEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
SoundEvents:SetScript("OnEvent", ApplySoundConfiguration)

-- Handle CVar changes
local function OnCVarChanged(event, cvar, value)
    if cvar == "Sound_OutputDriverIndex" and value ~= "0" then
        SetCVar("Sound_OutputDriverIndex", "0")
        Sound_GameSystem_RestartSoundSystem()
    end
end

local CVarEvents = CreateFrame("Frame")
CVarEvents:RegisterEvent("CVAR_UPDATE")
CVarEvents:SetScript("OnEvent", OnCVarChanged)