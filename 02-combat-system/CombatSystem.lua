-- CombatSystem.lua
-- ServerScriptService/CombatSystem
-- Server-authoritative melee combat with spatial hitbox queries, cooldowns, and knockback.
-- Author: Subi Hackwell

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local SwingRE = ReplicatedStorage.RemoteEvents.SwingRE
local HitEffect = ReplicatedStorage.RemoteEvents.HitEffect

local COOLDOWN = 0.5
local HITBOX_SIZE = Vector3.new(5, 5, 6)
local HITBOX_OFFSET = Vector3.new(0, 0, -3)
local BASE_DAMAGE = 25
local KNOCKBACK_FORCE = 60

local cooldowns = {}

local function getCharacterRoot(player)
	local char = player.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function createHitbox(cframe, size)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 0.7
	part.BrickColor = BrickColor.new("Bright red")
	part.Size = size
	part.CFrame = cframe
	part.Parent = workspace
	Debris:AddItem(part, 0.1)
	return part
end

SwingRE.OnServerEvent:Connect(function(player)
	local now = tick()
	local userId = player.UserId

	if cooldowns[userId] and (now - cooldowns[userId]) < COOLDOWN then return end
	cooldowns[userId] = now

	local root = getCharacterRoot(player)
	if not root then return end

	local hitboxCFrame = root.CFrame * CFrame.new(HITBOX_OFFSET)
	createHitbox(hitboxCFrame, HITBOX_SIZE)

	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = {player.Character}
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude

	local parts = workspace:GetPartBoundsInBox(hitboxCFrame, HITBOX_SIZE, overlapParams)
	local hitPlayers = {}

	for _, part in ipairs(parts) do
		local character = part.Parent
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health > 0 and not hitPlayers[character] then
			hitPlayers[character] = true
			humanoid:TakeDamage(BASE_DAMAGE)

			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local direction = (rootPart.Position - root.Position).Unit
				local bv = Instance.new("BodyVelocity")
				bv.Velocity = (direction + Vector3.new(0, 0.4, 0)) * KNOCKBACK_FORCE
				bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				bv.P = 1e4
				bv.Parent = rootPart
				Debris:AddItem(bv, 0.15)
			end

			HitEffect:FireAllClients(rootPart and rootPart.Position or root.Position)
		end
	end
end)
