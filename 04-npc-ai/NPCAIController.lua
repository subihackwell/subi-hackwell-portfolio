-- NPCAIController.lua
-- ServerScriptService/NPCAIController
-- Multi-state NPC AI: Patrol -> Chase -> Attack, powered by PathfindingService.
-- Attach "NPC" tag via CollectionService to any NPC model to activate.
-- Author: Subi Hackwell

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local DETECT_RANGE = 30
local ATTACK_RANGE = 5
local ATTACK_DAMAGE = 15
local ATTACK_COOLDOWN = 1.5
local PATROL_RADIUS = 20
local UPDATE_RATE = 0.5

local function getNearestPlayer(npcRoot)
	local nearest, shortest = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			local dist = (root.Position - npcRoot.Position).Magnitude
			if dist < shortest then
				nearest, shortest = player, dist
			end
		end
	end
	return nearest, shortest
end

local function walkTo(humanoid, target)
	local path = PathfindingService:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
	})
	local success = pcall(function()
		path:ComputeAsync(humanoid.Parent.HumanoidRootPart.Position, target)
	end)
	if not success or path.Status ~= Enum.PathStatus.Success then return end
	for _, waypoint in ipairs(path:GetWaypoints()) do
		if waypoint.Action == Enum.PathWaypointAction.Jump then
			humanoid.Jump = true
		end
		humanoid:MoveTo(waypoint.Position)
		humanoid.MoveToFinished:Wait()
	end
end

local function setupNPC(npc)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	local root = npc:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end

	local lastAttack = 0
	local origin = root.Position

	task.spawn(function()
		while humanoid.Health > 0 do
			task.wait(UPDATE_RATE)
			local target, dist = getNearestPlayer(root)

			if target and dist <= ATTACK_RANGE then
				local char = target.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum and (tick() - lastAttack) >= ATTACK_COOLDOWN then
					hum:TakeDamage(ATTACK_DAMAGE)
					lastAttack = tick()
				end
			elseif target and dist <= DETECT_RANGE then
				local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
				if targetRoot then
					walkTo(humanoid, targetRoot.Position)
				end
			else
				local angle = math.random() * math.pi * 2
				local patrolTarget = origin + Vector3.new(
					math.cos(angle) * math.random(5, PATROL_RADIUS),
					0,
					math.sin(angle) * math.random(5, PATROL_RADIUS)
				)
				walkTo(humanoid, patrolTarget)
				task.wait(math.random(2, 5))
			end
		end
	end)
end

for _, npc in ipairs(CollectionService:GetTagged("NPC")) do
	setupNPC(npc)
end
CollectionService:GetInstanceAddedSignal("NPC"):Connect(setupNPC)
