-- Function to handle faster looting
local function FasterLoot()
  if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
    local lootMethod, masterLooter = GetLootMethod()
    if lootMethod == "master" and masterLooter == UnitName("player") then
      return
    end
    local numLoot = GetNumLootItems()
    if not numLoot then return end
    LootFrame:Hide()
    for i = numLoot, 1, -1 do
      LootSlot(i)
    end
  end
end

-- Register event for faster looting
local LootEvents = CreateFrame("Frame")
LootEvents:RegisterEvent("LOOT_READY")
LootEvents:SetScript("OnEvent", FasterLoot)

-- Function to repair items
local function RepairItems()
  if CanMerchantRepair() then
      RepairAllItems()
  end
end




-- Function to sell grey items
local function SellGreyItems()
  for NumBags = 0, 4 do
      for NumSlots = 1, C_Container.GetContainerNumSlots(NumBags) do
          local ItemLink = C_Container.GetContainerItemLink(NumBags, NumSlots)
          if ItemLink then
              local _, _, ItemRarity = GetItemInfo(ItemLink)
              if ItemRarity == 0 then
                  C_Container.UseContainerItem(NumBags, NumSlots)
              end
          end
      end
  end
end

-- Function to handle auto sell and repair
local function AutoSellRepair()
  RepairItems()
  SellGreyItems()
  C_Timer.After(0, SellGreyItems)
end

-- Register event for auto sell and repair
local MerchantEvents = CreateFrame("Frame")
MerchantEvents:RegisterEvent("MERCHANT_SHOW")
MerchantEvents:SetScript("OnEvent", AutoSellRepair)