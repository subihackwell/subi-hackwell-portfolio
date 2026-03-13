-- ShopSystem.lua
-- ServerScriptService/ShopSystem
-- Server-validated economy system. All purchases verified server-side — no client can spoof transactions.
-- Author: Subi Hackwell

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataManager = require(game.ServerScriptService.DataManager)

local BuyRF = ReplicatedStorage.RemoteFunctions.BuyItem

local SHOP_ITEMS = {
	SpeedBoost = { price = 100, description = "Double speed for 30s" },
	ExtraLife   = { price = 250, description = "Extra life" },
	GoldenTool  = { price = 500, description = "2x harvest speed" },
}

BuyRF.OnServerInvoke = function(player, itemName)
	local item = SHOP_ITEMS[itemName]
	if not item then
		return false, "Item does not exist"
	end

	local coins = DataManager.Get(player, "Coins")
	if not coins or coins < item.price then
		return false, "Not enough coins"
	end

	DataManager.Increment(player, "Coins", -item.price)
	local inv = DataManager.Get(player, "Inventory")
	table.insert(inv, itemName)
	DataManager.Set(player, "Inventory", inv)

	return true, ("Purchased %s for %d coins!"):format(itemName, item.price)
end
