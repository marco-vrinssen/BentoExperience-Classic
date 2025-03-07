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
  if not GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
    return
  end
  
  local lootMethod = GetLootMethod()
  if lootMethod == "master" and UnitIsUnit("player", GetMasterLooterGUID()) then
    return
  end
  
  local numLoot = GetNumLootItems()
  if not numLoot or numLoot <= 0 then 
    return 
  end

  if LootFrame:IsShown() then
    LootFrame:SetAlpha(0)
  end
  
  for i = numLoot, 1, -1 do
    if GetLootSlotInfo(i) then
      LootSlot(i)
    end
  end
end

local lootEvents = CreateFrame("Frame")
lootEvents:RegisterEvent("LOOT_READY")
lootEvents:SetScript("OnEvent", lootItems)