-- RoundManager.lua
-- ServerScriptService/RoundManager
-- Full game loop: Lobby -> Countdown -> Round -> Results. Broadcasts live status to all clients.
-- Author: Subi Hackwell

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StatusRE = ReplicatedStorage.RemoteEvents.UpdateStatus
local MIN_PLAYERS = 2
local LOBBY_WAIT = 30
local ROUND_DURATION = 180
local RESULTS_DURATION = 10

local RoundManager = {}
local roundActive = false

local function broadcast(message)
	StatusRE:FireAllClients(message)
end

local function getActivePlayers()
	return Players:GetPlayers()
end

local function teleportToMap(players)
	for _, player in ipairs(players) do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = workspace.MapSpawn.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5))
		end
	end
end

local function teleportToLobby(players)
	for _, player in ipairs(players) do
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = workspace.LobbySpawn.CFrame
		end
	end
end

function RoundManager.Start()
	while true do
		roundActive = false
		broadcast("Waiting for players... (" .. #getActivePlayers() .. "/" .. MIN_PLAYERS .. ")")

		repeat task.wait(1) until #getActivePlayers() >= MIN_PLAYERS

		for i = LOBBY_WAIT, 1, -1 do
			broadcast("Round starting in " .. i .. "s")
			task.wait(1)
		end

		roundActive = true
		local roundPlayers = getActivePlayers()
		teleportToMap(roundPlayers)
		broadcast("Round started! Survive!")

		local endTime = tick() + ROUND_DURATION
		while tick() < endTime and roundActive do
			local remaining = math.floor(endTime - tick())
			broadcast("Time remaining: " .. remaining .. "s")
			task.wait(1)
		end

		broadcast("Round over! Showing results...")
		teleportToLobby(getActivePlayers())
		task.wait(RESULTS_DURATION)
	end
end

task.spawn(RoundManager.Start)
return RoundManager
