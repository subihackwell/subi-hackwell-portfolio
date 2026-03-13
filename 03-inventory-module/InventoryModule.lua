-- InventoryModule.lua
-- ReplicatedStorage/InventoryModule
-- OOP-based inventory system with stacking, slot management, and item validation.
-- Author: Subi Hackwell

local InventoryModule = {}
InventoryModule.__index = InventoryModule

function InventoryModule.new(maxSlots)
	return setmetatable({
		slots = {},
		maxSlots = maxSlots or 20,
	}, InventoryModule)
end

function InventoryModule:AddItem(itemData)
	if #self.slots >= self.maxSlots then
		return false, "Inventory full"
	end
	for _, slot in ipairs(self.slots) do
		if slot.name == itemData.name and slot.stackable then
			slot.quantity += (itemData.quantity or 1)
			return true
		end
	end
	table.insert(self.slots, {
		name = itemData.name,
		quantity = itemData.quantity or 1,
		icon = itemData.icon or "rbxassetid://0",
		stackable = itemData.stackable or false,
	})
	return true
end

function InventoryModule:RemoveItem(name, quantity)
	quantity = quantity or 1
	for i, slot in ipairs(self.slots) do
		if slot.name == name then
			slot.quantity -= quantity
			if slot.quantity <= 0 then
				table.remove(self.slots, i)
			end
			return true
		end
	end
	return false, "Item not found"
end

function InventoryModule:HasItem(name, quantity)
	quantity = quantity or 1
	for _, slot in ipairs(self.slots) do
		if slot.name == name and slot.quantity >= quantity then
			return true
		end
	end
	return false
end

function InventoryModule:GetAll()
	return self.slots
end

return InventoryModule
