-- InteractionModule.lua
-- ReplicatedStorage/InteractionModule
-- Reusable ProximityPrompt wrapper. Plug into any interactable in one line.
-- Author: Subi Hackwell

local InteractionModule = {}

function InteractionModule.Create(part, options)
	options = options or {}

	local prompt = Instance.new("ProximityPrompt")
	prompt.ActionText    = options.actionText    or "Interact"
	prompt.ObjectText    = options.objectText    or part.Name
	prompt.HoldDuration  = options.holdDuration  or 0
	prompt.MaxActivationDistance = options.distance or 8
	prompt.KeyboardKeyCode = options.key or Enum.KeyCode.E
	prompt.Parent = part

	prompt.Triggered:Connect(function(player)
		if options.onTrigger then
			options.onTrigger(player, part)
		end
	end)

	return prompt
end

return InteractionModule

--[[
USAGE EXAMPLE:
	local InteractionModule = require(ReplicatedStorage.InteractionModule)
	local DataManager = require(ServerScriptService.DataManager)

	InteractionModule.Create(workspace.Chest, {
		actionText = "Open",
		objectText = "Treasure Chest",
		holdDuration = 1.5,
		onTrigger = function(player)
			DataManager.Increment(player, "Coins", 50)
		end,
	})
]]
