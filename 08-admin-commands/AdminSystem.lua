-- AdminSystem.lua
-- ServerScriptService/AdminSystem
-- Permission-tiered admin command system. Add new commands in one block.
-- Author: Subi Hackwell

local Players = game:GetService("Players")

local ADMINS = {
	[123456789] = 3, -- Owner   (replace with your UserId)
	[987654321] = 2, -- Mod     (replace with mod UserIds)
}
local PREFIX = "/"

local commands = {}

commands.kick = {
	level = 2,
	run = function(caller, args)
		local target = Players:FindFirstChild(args[1])
		if target then target:Kick(args[2] or "Kicked by admin") end
	end
}

commands.speed = {
	level = 3,
	run = function(caller, args)
		local target = Players:FindFirstChild(args[1])
		local speed = tonumber(args[2]) or 16
		if target and target.Character then
			local hum = target.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = math.clamp(speed, 0, 100) end
		end
	end
}

commands.heal = {
	level = 2,
	run = function(caller, args)
		local target = Players:FindFirstChild(args[1]) or caller
		if target and target.Character then
			local hum = target.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end
	end
}

commands.announce = {
	level = 2,
	run = function(caller, args)
		local msg = table.concat(args, " ")
		for _, p in ipairs(Players:GetPlayers()) do
			game.ReplicatedStorage.RemoteEvents.Announce:FireClient(p, msg)
		end
	end
}

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		if msg:sub(1, 1) ~= PREFIX then return end
		local callerLevel = ADMINS[player.UserId] or 0
		if callerLevel == 0 then return end

		local parts = msg:sub(2):split(" ")
		local cmdName = parts[1]:lower()
		local args = {table.unpack(parts, 2)}

		local cmd = commands[cmdName]
		if cmd and callerLevel >= cmd.level then
			local ok, err = pcall(cmd.run, player, args)
			if not ok then warn("[Admin] Error: " .. tostring(err)) end
		end
	end)
end)
