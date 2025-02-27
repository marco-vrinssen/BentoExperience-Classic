-- AUTO SELL AND REPAIR ITEMS

local function RepairItems()
    if CanMerchantRepair() then
        RepairAllItems()
    end
end

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

local function AutoSellRepair()
    RepairItems()
    SellGreyItems()
    C_Timer.After(0, SellGreyItems)
end

local MerchantFrame = CreateFrame("Frame")
MerchantFrame:RegisterEvent("MERCHANT_SHOW")
MerchantFrame:SetScript("OnEvent", AutoSellRepair)




-- SPEED UP AUTO LOOTING ITEMSs

local function LootItems()
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

local LootFrame = CreateFrame("Frame")
LootFrame:RegisterEvent("LOOT_READY")
LootFrame:SetScript("OnEvent", LootItems)