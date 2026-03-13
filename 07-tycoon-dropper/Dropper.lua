-- Dropper.lua
-- Place inside a Dropper model in Workspace
-- Attribute-driven resource generation — no hardcoding per instance.
-- Set attributes on the Dropper part: ItemName, DropRate, ItemValue
-- Author: Subi Hackwell

local dropper = script.Parent
local dropPoint = dropper.DropPoint
local ITEM_NAME = dropper:GetAttribute("ItemName") or "Item"
local DROP_RATE  = dropper:GetAttribute("DropRate")  or 3
local ITEM_VALUE = dropper:GetAttribute("ItemValue")  or 10

local function spawnDrop()
	local part = Instance.new("Part")
	part.Name = ITEM_NAME
	part.Size = Vector3.new(1, 1, 1)
	part.BrickColor = BrickColor.new("Bright green")
	part.CFrame = dropPoint.CFrame
	part:SetAttribute("Value", ITEM_VALUE)
	part.Parent = workspace.DroppedItems
	game:GetService("Debris"):AddItem(part, 30)
end

while true do
	task.wait(DROP_RATE)
	spawnDrop()
end
