local function CommandsIntro()
    print("/bentocmd for available commands.")
end


local IntroEvents = CreateFrame("Frame")
IntroEvents:RegisterEvent("PLAYER_LOGIN")
IntroEvents:SetScript("OnEvent", CommandsIntro)


SLASH_BENTOCMD1 = "/bentocmd"
SlashCmdList["BENTOCMD"] = function(msg, editBox)
    if msg == "" then
        print("|cFFFFD500/f KEYWORD|r: Filters all active channels for KEYWORD and reposts matching messages.")
        print("|cFFFFD500/f KEYWORD1+KEYWORD2|r: Filters all active channels for the combination of KEYWORD1 and KEYWORD2 and reposts matching messages.")
        print("|cFFFFD500/f|r: Clears and stops the filtering.")

        print("|cFFFFD500/bc MESSAGE|r: Broadcasts the MESSAGE across all joined channels.")
        print("|cFFFFD500/bc N1-N2 MESSAGE|r: Broadcasts the MESSAGE across all specified channels, where N1 and N2 are indicating the inclusive range of channels to be targeted.")

        print("|cFFFFD500/ww MESSAGE|r: Sends the MESSAGE to all players in a currently open /who instance.")
        print("|cFFFFD500/ww N MESSAGE|r: Sends the MESSAGE to the first N count of players in a currently open /who instance.")
        print("|cFFFFD500/ww -CLASS MESSAGE|r: Sends the MESSAGE to all players who are not of the specified CLASS in a currently open /who instance.")
        print("|cFFFFD500/ww N -CLASS MESSAGE|r: Sends the MESSAGE to the first N count of players who are not of the specified CLASS in a currently open /who instance.")
        print("|cFFFFD500/wl N MESSAGE|r: Sends the MESSAGE to the last N players who whispered you.")

        print("|cFFFFD500/rc|r: Perform a ready check.")
        print("|cFFFFD500/q|r: Leaves the current party or raid.")
        print("|cFFFFD500/ui|r: Reloads the user interface.")
        print("|cFFFFD500/gx|r: Restarts the graphics engine.")
        print("|cFFFFD500/rl|r: Reloads the user interface and the graphics engine.")
        print("|cFFFFD500/lua|r: Toggles the display of LUA errors.")
    end
end