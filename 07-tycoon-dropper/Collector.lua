-- Collector.lua
-- Place inside a Collector model in Workspace
-- Collects nearby dropped items and credits the touching player.
-- Author: Subi Hackwell

local collector = script.Parent
local triggerPart = collector.Trigger
local Players = game:GetService("Players")
local DataManager = require(game.ServerScriptService.DataManager)

triggerPart.Touched:Connect(function(hit)
	local droppedItems = workspace:FindFirstChild("DroppedItems")
	if not droppedItems then return end

	local character = hit.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	for _, item in ipairs(droppedItems:GetChildren()) do
		local dist = (item.Position - triggerPart.Position).Magnitude
		if dist <= 8 then
			local value = item:GetAttribute("Value") or 0
			DataManager.Increment(player, "Coins", value)
			item:Destroy()
		end
	end
end)
