# Anti-Cheat System

Server-side exploit detection for speed hacks, fly hacks, and teleport exploits. Progressive violation system auto-kicks repeat offenders.

## Detections
| Check | Threshold | Description |
|-------|-----------|-------------|
| Speed | > 28 studs/s | Flags abnormal movement speed |
| Teleport | > 80 studs/frame | Flags sudden large position jumps |
| Fly | Y gain > 10 outside jump states | Flags sustained upward movement |

## Violation System
- Each flag adds +1 violation to the player
- At 5 violations → auto-kick with message
- Violations cleared on player leave

## Tuning
Adjust constants at the top of the script:
```lua
local MAX_SPEED = 28          -- increase if your game has speed boosts
local TELEPORT_THRESHOLD = 80 -- increase for games with teleport mechanics
```

## Where to place
`ServerScriptService/AntiCheat`
