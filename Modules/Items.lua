-- AUTO SELL AND REPAIR ITEMS

local function repairItems()
  if CanMerchantRepair() then
    RepairAllItems()
  end
end


local function sellGreyItems()
  for numBags = 0, 4 do
    for numSlots = 1, C_Container.GetContainerNumSlots(numBags) do
      local itemLink = C_Container.GetContainerItemLink(numBags, numSlots)
      if itemLink then
        local _, _, itemRarity = GetItemInfo(itemLink)
        if itemRarity == 0 then
          C_Container.UseContainerItem(numBags, numSlots)
        end
      end
    end
  end

end


local function autoSellRepair()
  repairItems()
  sellGreyItems()
  C_Timer.After(0, sellGreyItems)
end


local merchantEvents = CreateFrame("Frame")
merchantEvents:RegisterEvent("MERCHANT_SHOW")
merchantEvents:SetScript("OnEvent", autoSellRepair)




-- SPEED UP AUTO LOOTING ITEMS

local function lootItems()

  
  if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
    local lootMethod, masterLooter = GetLootMethod()
    if lootMethod == "master" and masterLooter == UnitName("player") then
      return
    end
    local numLoot = GetNumLootItems()
    if not numLoot then return end
    LootFrame:Hide()
    LootFrame:SetAlpha(0)
    for i = numLoot, 1, -1 do
      LootSlot(i)
    end
    LootFrame:Show()
    LootFrame:SetAlpha(1)
  end

end


local lootEvents = CreateFrame("Frame")
lootEvents:RegisterEvent("LOOT_READY")
lootEvents:SetScript("OnEvent", lootItems)