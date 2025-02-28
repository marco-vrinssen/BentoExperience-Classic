-- UPDATE MICRO MENU POSITIONING

local function UpdateMicroMenuButtons()
  local microButtons = {}

  for name in pairs(_G) do
    if type(name) == "string" and string.match(name, "^%a+MicroButton$") then
      local button = _G[name]
      if type(button) == "table" and button.IsVisible and button:IsVisible() then
        table.insert(microButtons, button)
      end
    end
  end
  
  local buttonWidth = CharacterMicroButton:GetWidth()
  local totalMenuWidth = buttonWidth * (#microButtons - 1)
  
  CharacterMicroButton:ClearAllPoints()
  CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -totalMenuWidth, 16)
end

local microMenuEvents = CreateFrame("Frame")
microMenuEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
microMenuEvents:SetScript("OnEvent", UpdateMicroMenuButtons)


-- RELOAD UI ON GAME MICRO MENU RIGHT CLICK

MainMenuMicroButton:HookScript("OnClick", function(self, buttonClicked)
  if buttonClicked == "RightButton" then
    ReloadUI()
  end
end)


-- UPDATE LFG BUTTON

local function MinimapLFGUpdate()
  if LFGMinimapFrameBorder then
      LFGMinimapFrameBorder:Hide()
  end
  if LFGMinimapFrame then
      LFGMinimapFrame:SetParent(Minimap)
      LFGMinimapFrame:ClearAllPoints()
      LFGMinimapFrame:SetSize(44, 44)
      LFGMinimapFrame:SetPoint("RIGHT", CharacterMicroButton, "LEFT", 4, -8)
  end
  if LFGMinimapFrameIcon then
      LFGMinimapFrameIcon:SetSize(40, 40)
      LFGMinimapFrameIcon:SetPoint("CENTER", LFGMinimapFrame, "CENTER", 0, 0)
  end
end

local MinimapLFGFrame = CreateFrame("Frame")
MinimapLFGFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
MinimapLFGFrame:SetScript("OnEvent", MinimapLFGUpdate)