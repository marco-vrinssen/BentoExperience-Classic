local itemSlotWidth, itemSlotHeight = 68, 68

-- Quality color definitions
local poorItemQuality = 0
local bagColors = { [poorItemQuality] = { r = 0.1, g = 0.1, b = 0.1 } }
local questItemQuality = 1  -- fixed index for quest items
bagColors[questItemQuality] = { r = 1, g = 1, b = 0 }

-- Default configuration
local defaultConfig = {
	bags     = 1,
	bank     = 1,
	char     = 1,
	inspect  = 1,
	merchant = 1,
	intensity = 0.5,
}

-- Global configuration table (loaded/modified by the addon)
config = config or {}

ItemQualityFrame:RegisterEvent("VARIABLES_LOADED")
ItemQualityFrame:RegisterEvent("ADDON_LOADED")
ItemQualityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
ItemQualityFrame:RegisterEvent("INSPECT_READY")
ItemQualityFrame:RegisterEvent("BAG_UPDATE")
ItemQualityFrame:RegisterEvent("BANKFRAME_OPENED")
ItemQualityFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")

ItemQualityFrame:SetScript("OnEvent", function(self, event, arg1)
	self[event](self, arg1)
end)

function ItemQualityFrame:VARIABLES_LOADED()
	-- copy defaults if key missing
	for k, v in pairs(defaultConfig) do
		if not config[k] then config[k] = v end
	end

	-- remove obsolete keys
	for k in pairs(config) do
		if defaultConfig[k] == nil then config[k] = nil end
	end
end

function ItemQualityFrame:ADDON_LOADED(arg1)
	if arg1 == addonName then
		print("|cFFFFFF00ColoredInventoryItem v" .. version .. ":|cFFFFFFFF Type /cii for configuration")
		hooksecurefunc("ToggleCharacter", function() ItemQualityFrame:characterFrame_OnToggle() end)
		hooksecurefunc("ToggleBackpack", function() ItemQualityFrame:backpack_OnShow() end)
		hooksecurefunc("ToggleBag", function(id) ItemQualityFrame:bag_OnToggle(id) end)
		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function() ItemQualityFrame:merchant_OnUpdate() end)
		hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function() ItemQualityFrame:buyback_OnUpdate() end)
	end

	if arg1 == "Blizzard_TradeSkillUI" then
		hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
			ItemQualityFrame:tradeskill_OnUpdate(id)
		end)
	end
end

function ItemQualityFrame:PLAYER_ENTERING_WORLD()
end

--- character frame events
function ItemQualityFrame:characterFrame_OnToggle()
	if CharacterFrame:IsShown() then
		ItemQualityFrame:characterFrame_OnShow()
	else
		ItemQualityFrame:characterFrame_OnHide()
	end
end

function ItemQualityFrame:characterFrame_OnShow()
	ItemQualityFrame:RegisterEvent("UNIT_INVENTORY_CHANGED")
	ItemQualityFrame:charFrame_UpdateBorders("player", "Character", config.char)
end

function ItemQualityFrame:characterFrame_OnHide()
	ItemQualityFrame:UnregisterEvent("UNIT_INVENTORY_CHANGED")
end

--- update player inventory
function ItemQualityFrame:UNIT_INVENTORY_CHANGED()
	ItemQualityFrame:charFrame_UpdateBorders("player", "Character", config.char)
end

--- bag update event
function ItemQualityFrame:BAG_UPDATE(arg1)
	ItemQualityFrame:refreshBag(arg1)
end

--- inspect frame event
function ItemQualityFrame:INSPECT_READY()
	ItemQualityFrame:charFrame_UpdateBorders("target", "Inspect", config.inspect)
end

--- bank frame opened
function ItemQualityFrame:BANKFRAME_OPENED()
	ItemQualityFrame:bankbags_UpdateBorders()
end

--- bank slots updated
function ItemQualityFrame:PLAYERBANKSLOTS_CHANGED()
	ItemQualityFrame:bankbags_UpdateBorders()
end

--- backpack opened event
function ItemQualityFrame:backpack_OnShow()
	local containerFrame = _G["ContainerFrame1"]
	if containerFrame.allBags then
		ItemQualityFrame:refreshAllBags()
	end
end

function ItemQualityFrame:refreshAllBags()
	for bagId = 0, NUM_BAG_SLOTS do
		OpenBag(bagId)
		ItemQualityFrame:refreshBag(bagId)
	end
end

--- open/close a bag
function ItemQualityFrame:bag_OnToggle(bagId)
	ItemQualityFrame:refreshBag(bagId)
end

--- refresh single bag content
function ItemQualityFrame:refreshBag(bagId)
	local frameId = IsBagOpen(bagId)
	if frameId then
		local nbSlots = C_Container.GetContainerNumSlots(bagId)
		for slot = 1, nbSlots do
			local slotFrameId = nbSlots + 1 - slot
			local slotFrameName = "ContainerFrame" .. frameId .. "Item" .. slotFrameId
			ItemQualityFrame:updateContainerSlot(bagId, slot, slotFrameName, config.bags)
		end
	end
end

--- update bank bag borders
function ItemQualityFrame:bankbags_UpdateBorders()
	local container = BANK_CONTAINER
	for slot = 1, C_Container.GetContainerNumSlots(container) do
		ItemQualityFrame:updateContainerSlot(container, slot, "BankFrameItem" .. slot, config.bank)
	end
end

--- update container (bag or bank) slot border
function ItemQualityFrame:updateContainerSlot(containerId, slotId, slotFrameName, show)
	show = show or 1
	local slotItem = _G[slotFrameName]
	if not slotItem.qborder then
		slotItem.qborder = ItemQualityFrame:createBorder(slotFrameName, slotItem, itemSlotWidth, itemSlotHeight)
	end
	local itemId = C_Container.GetContainerItemID(containerId, slotId)
	if itemId and show == 1 then
		local quality = GetItemQuality(itemId)
		if quality and quality > LE_ITEM_QUALITY_COMMON then
			local r, g, b = GetQualityColor(quality)
			slotItem.qborder:SetVertexColor(r, g, b)
			slotItem.qborder:SetAlpha(config.intensity)
			slotItem.qborder:Show()
		else
			slotItem.qborder:Hide()
		end
	else
		slotItem.qborder:Hide()
	end
end

local characterSlotTypes = {
	"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist",
	"Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1",
	"MainHand", "SecondaryHand", "Ranged", "Ammo",
}

--- update character frame item borders
function ItemQualityFrame:charFrame_UpdateBorders(unit, frameType, show)
	show = show or 1
	for _, slotType in ipairs(characterSlotTypes) do
		local slotId = select(1, GetInventorySlotInfo(slotType .. "Slot"))
		local quality = GetInventoryItemQuality(unit, slotId)
		local slotName = frameType .. slotType .. "Slot"
		if _G[slotName] then
			local slotItem = _G[slotName]
			if not slotItem.qborder then
				local width, height = itemSlotWidth, itemSlotHeight
				if slotType == "Ammo" then width, height = 58, 58 end
				slotItem.qborder = ItemQualityFrame:createBorder(slotName, slotItem, width, height)
			end
			if quality and show == 1 then
				local r, g, b = GetQualityColor(quality)
				slotItem.qborder:SetVertexColor(r, g, b)
				slotItem.qborder:SetAlpha(config.intensity)
				slotItem.qborder:Show()
			else
				slotItem.qborder:Hide()
			end
		end
	end
end

--- merchant trade window update
function ItemQualityFrame:MERCHANT_UPDATE()
	ItemQualityFrame:merchantItems_Update()
	if not BuybackBG:IsShown() then
		ItemQualityFrame:merchantMainBuyBack_Update()
	end
end

--- merchant page update event
function ItemQualityFrame:merchant_OnUpdate()
	ItemQualityFrame:merchantItems_Update(GetMerchantItemLink)
	ItemQualityFrame:merchantMainBuyBack_Update()
end

--- merchant buyback page update event
function ItemQualityFrame:buyback_OnUpdate()
	ItemQualityFrame:merchantItems_Update(GetBuybackItemLink)
end

--- update merchant trade window item borders
function ItemQualityFrame:merchantItems_Update(itemLinkFunc)
	for slotId = 1, 12 do
		local slotName = "MerchantItem" .. slotId .. "ItemButton"
		local itemFrame = _G[slotName]
		if not itemFrame.qborder then
			itemFrame.qborder = ItemQualityFrame:createBorder(slotName, itemFrame, itemSlotWidth, itemSlotHeight)
		end
		local link = itemLinkFunc(slotId)
		if link then
			ItemQualityFrame:updateSlotBorderColor(itemFrame, link, LE_ITEM_QUALITY_COMMON)
		else
			itemFrame.qborder:Hide()
		end
	end
end

--- update buyback button border
function ItemQualityFrame:merchantMainBuyBack_Update()
	local slotName = "MerchantBuyBackItemItemButton"
	local item = _G[slotName]
	if not item.qborder then
		item.qborder = ItemQualityFrame:createBorder(slotName, item, itemSlotWidth, itemSlotHeight)
	end
	local lastLink = FindLastBuybackItem()
	if lastLink then
		ItemQualityFrame:updateSlotBorderColor(item, lastLink, LE_ITEM_QUALITY_COMMON)
	else
		item.qborder:Hide()
	end
end

function ItemQualityFrame:updateSlotBorderColor(item, itemLink, minQuality)
	minQuality = minQuality or poorItemQuality
	local quality = GetItemQuality(itemLink)
	if quality and quality > minQuality then
		local r, g, b = GetQualityColor(quality)
		item.qborder:SetVertexColor(r, g, b)
		item.qborder:SetAlpha(config.intensity)
		item.qborder:Show()
	else
		item.qborder:Hide()
	end
end

--- find last item in buyback queue
function FindLastBuybackItem()
	local lastLink = nil
	for slotId = 1, 12 do
		local link = GetBuybackItemLink(slotId)
		if link then lastLink = link end
	end
	return lastLink
end

--- tradeskill item and reagent borders
function ItemQualityFrame:tradeskill_OnUpdate(id)
	ItemQualityFrame:updateTradeSkillItem(id)
	ItemQualityFrame:updateTradeSkillReageant(id)
end

function ItemQualityFrame:updateTradeSkillItem(id)
	local slotName = "TradeSkillSkillIcon"
	local item = _G[slotName]
	if not item.qborder then
		item.qborder = ItemQualityFrame:createBorder(slotName, item, itemSlotWidth, itemSlotHeight)
	end
	local link = GetTradeSkillItemLink(id)
	if link then
		ItemQualityFrame:updateSlotBorderColor(item, link, LE_ITEM_QUALITY_COMMON)
	else
		item.qborder:Hide()
	end
end

function ItemQualityFrame:updateTradeSkillReageant(id)
	local reagentCount = GetTradeSkillNumReagents(id)
	for index = 1, reagentCount do
		local slotName = "TradeSkillReagent" .. index
		local item = _G[slotName]
		if not item.qborder then
			item.qborder = ItemQualityFrame:createBorder(slotName, item, itemSlotWidth, itemSlotHeight, -54)
		end
		local link = GetTradeSkillReagentItemLink(id, index)
		if link then
			ItemQualityFrame:updateSlotBorderColor(item, link, LE_ITEM_QUALITY_COMMON)
		else
			item.qborder:Hide()
		end
	end
end

--- create a border texture for an inventory slot
function ItemQualityFrame:createBorder(name, parent, width, height, x, y)
	x = x or 0
	y = y or 1
	local border = parent:CreateTexture(name .. "Quality", "OVERLAY")
	border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	border:SetBlendMode("ADD")
	border:SetAlpha(config.intensity)
	border:SetHeight(height)
	border:SetWidth(width)
	border:SetPoint("CENTER", parent, "CENTER", x, y)
	border:Hide()
	return border
end

--- custom quality color function
function GetQualityColor(quality)
	local clr = bagColors[quality]
	return clr.r, clr.g, clr.b
end

--- custom quality function for items
function GetItemQuality(itemId)
	local quality, _, _, _, _, _, _, _, _, classId = select(3, GetItemInfo(itemId))
	if classId == 12 then quality = questItemQuality end
	return quality
end