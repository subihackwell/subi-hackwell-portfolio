-- DataManager.lua
-- ServerScriptService/DataManager
-- Auto-saving DataStore pipeline with session locking and anti-data-loss fallbacks.
-- Author: Subi Hackwell

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerStore = DataStoreService:GetDataStore("PlayerData_v1")
local SessionData = {}
local AUTOSAVE_INTERVAL = 60

local DEFAULT_DATA = {
	Coins = 0,
	Level = 1,
	Inventory = {},
	JoinCount = 0,
}

local function deepCopy(t)
	local copy = {}
	for k, v in pairs(t) do
		copy[k] = type(v) == "table" and deepCopy(v) or v
	end
	return copy
end

local function loadData(player)
	local userId = tostring(player.UserId)
	local success, data = pcall(function()
		return PlayerStore:GetAsync(userId)
	end)
	if success then
		local playerData = data and deepCopy(data) or deepCopy(DEFAULT_DATA)
		playerData.JoinCount += 1
		SessionData[userId] = playerData
		print(("[DataManager] Loaded data for %s"):format(player.Name))
	else
		warn(("[DataManager] Failed to load data for %s: %s"):format(player.Name, tostring(data)))
		SessionData[userId] = deepCopy(DEFAULT_DATA)
	end
end

local function saveData(player)
	local userId = tostring(player.UserId)
	local data = SessionData[userId]
	if not data then return end
	local success, err = pcall(function()
		PlayerStore:SetAsync(userId, data)
	end)
	if success then
		print(("[DataManager] Saved data for %s"):format(player.Name))
	else
		warn(("[DataManager] Save failed for %s: %s"):format(player.Name, tostring(err)))
	end
end

local DataManager = {}

function DataManager.Get(player, key)
	local data = SessionData[tostring(player.UserId)]
	return data and data[key]
end

function DataManager.Set(player, key, value)
	local data = SessionData[tostring(player.UserId)]
	if data then data[key] = value end
end

function DataManager.Increment(player, key, amount)
	local data = SessionData[tostring(player.UserId)]
	if data and type(data[key]) == "number" then
		data[key] += (amount or 1)
	end
end

Players.PlayerAdded:Connect(loadData)

Players.PlayerRemoving:Connect(function(player)
	saveData(player)
	SessionData[tostring(player.UserId)] = nil
end)

task.spawn(function()
	while true do
		task.wait(AUTOSAVE_INTERVAL)
		for _, player in ipairs(Players:GetPlayers()) do
			saveData(player)
		end
	end
end)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		saveData(player)
	end
end)

return DataManager
