# Proximity Interaction Module

Reusable `ProximityPrompt` wrapper. Turn any part into an interactable in one function call.

## Usage
```lua
local InteractionModule = require(ReplicatedStorage.InteractionModule)

-- Simple interaction
InteractionModule.Create(workspace.Door, {
    actionText = "Open",
    objectText = "Door",
    onTrigger = function(player)
        workspace.Door.CFrame *= CFrame.new(0, 0, 5)
    end,
})

-- Hold-to-interact chest
InteractionModule.Create(workspace.Chest, {
    actionText = "Loot",
    holdDuration = 2,
    distance = 6,
    onTrigger = function(player)
        DataManager.Increment(player, "Coins", 100)
    end,
})
```

## Options
| Option | Default | Description |
|--------|---------|-------------|
| `actionText` | "Interact" | Button label |
| `objectText` | part.Name | Object label |
| `holdDuration` | 0 | Seconds to hold |
| `distance` | 8 | Max activation studs |
| `key` | E | Keyboard key |
| `onTrigger` | nil | Callback function |

## Where to place
`ReplicatedStorage/InteractionModule` (ModuleScript)
