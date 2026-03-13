# Inventory Module

OOP-based inventory system with slot management, item stacking, and validation.

## Features
- Configurable max slot count
- Stacking support for stackable items
- Clean API: `AddItem`, `RemoveItem`, `HasItem`, `GetAll`
- Returns error strings on failure (no silent errors)

## Usage
```lua
local InventoryModule = require(ReplicatedStorage.InventoryModule)

local inv = InventoryModule.new(20) -- 20 slot inventory

inv:AddItem({ name = "Sword", quantity = 1, stackable = false })
inv:AddItem({ name = "Potion", quantity = 5, stackable = true })

print(inv:HasItem("Potion", 3)) -- true
inv:RemoveItem("Potion", 2)
```

## Where to place
`ReplicatedStorage/InventoryModule` (ModuleScript)
