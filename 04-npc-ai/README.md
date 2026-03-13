# NPC AI Controller

Multi-state NPC AI system: Patrol → Chase → Attack. Uses `PathfindingService` for smart navigation around obstacles.

## States
| State | Trigger | Behavior |
|-------|---------|----------|
| Patrol | No player in range | Walks to random point near spawn |
| Chase | Player within 30 studs | Pathfinds to player |
| Attack | Player within 5 studs | Deals damage on cooldown |

## Features
- Works on any NPC tagged `"NPC"` via `CollectionService`
- Auto-activates on new NPCs added at runtime
- Configurable ranges, damage, and cooldowns via constants
- Handles pathfinding failures gracefully

## Setup
1. Tag your NPC model with the `NPC` tag in CollectionService
2. Place script in `ServerScriptService`
3. NPC must have a `Humanoid` and `HumanoidRootPart`
