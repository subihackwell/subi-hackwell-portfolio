-- AntiCheat.lua
-- ServerScriptService/AntiCheat
-- Server-side detection for speed hacks, fly hacks, and teleport exploits.
-- Progressive violation system — auto-kicks after 5 flags.
-- Author: Subi Hackwell

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local MAX_SPEED = 28
local TELEPORT_THRESHOLD = 80
local CHECK_RATE = 0.2

local lastPositions = {}
local violations = {}

local function flag(player, reason)
	violations[player.UserId] = (violations[player.UserId] or 0) + 1
	warn(("[AntiCheat] %s flagged: %s (x%d)"):format(player.Name, reason, violations[player.UserId]))
	if violations[player.UserId] >= 5 then
		player:Kick("Kicked for suspicious activity.")
	end
end

local function checkPlayer(player)
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum  = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health <= 0 then return end

	local userId = player.UserId
	local pos = root.Position
	local last = lastPositions[userId]

	if last then
		local delta = (pos - last.pos).Magnitude
		local elapsed = tick() - last.time
		local speed = delta / elapsed

		if speed > MAX_SPEED and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
			flag(player, ("Speed %.1f studs/s"):format(speed))
		end

		if delta > TELEPORT_THRESHOLD then
			flag(player, ("Teleport %.1f studs"):format(delta))
		end

		if (pos.Y - last.pos.Y) > 10
			and hum:GetState() ~= Enum.HumanoidStateType.Jumping
			and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
			flag(player, "Possible fly hack")
		end
	end

	lastPositions[userId] = { pos = pos, time = tick() }
end

RunService.Heartbeat:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		checkPlayer(player)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	lastPositions[player.UserId] = nil
	violations[player.UserId] = nil
end)
