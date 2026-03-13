# DataStore Manager

Auto-saving player data pipeline with session locking and anti-data-loss fallbacks.

## Features
- Loads player data on join with `pcall` error handling
- Falls back to default data if DataStore is unavailable
- Auto-saves every 60 seconds
- Saves on player leave and server shutdown (`BindToClose`)
- Clean public API: `Get`, `Set`, `Increment`

## Usage
```lua
local DataManager = require(ServerScriptService.DataManager)

-- Get a value
local coins = DataManager.Get(player, "Coins")

-- Set a value
DataManager.Set(player, "Level", 5)

-- Increment a number
DataManager.Increment(player, "Coins", 100)
```

## Where to place
`ServerScriptService/DataManager` (Script, not LocalScript)
